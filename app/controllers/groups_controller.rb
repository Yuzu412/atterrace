class GroupsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_group, only: [:edit, :update]
    # --- 追記ここから (before_action) ---
    # 招待リンク機能で :id を使うアクションを追加
    before_action :set_group_for_invitation, only: [:invitation_link, :join, :join_group]
   
    # 招待リンクを生成する前に、トークンを（再）生成する
    before_action :create_invitation_token, only: [:invitation_link]
    # --- 追記ここまで ---



    def index
        @group = Group.find(params[:id])
        @group_lists = Group.all
        @group_joining = GroupUser.where(user_id: current_user.id)
        @group_lists_none = "グループに参加していません。"
        @last_group = Group.find_by(id: session[:last_group_id])
    end


    def new
        @group = Group.new
        @group.users << current_user
        @members = @group.users
    end

    def create
        @group = Group.new(group_params)
        if @group.save
          redirect_to @group, notice: "グループを作成しました！"
        else
          render :new, status: :unprocessable_entity
        end
    end


    def show
        @group = Group.find(params[:id])
        session[:last_group_id] = @group.id
        @tweets = @group.tweets.includes(:user).order(created_at: :desc)
        @group_lists = Group.all
        @group_joining = GroupUser.where(user_id: current_user.id)
        @group_lists_none = "グループに参加していません。"
        @last_group = Group.find_by(id: session[:last_group_id])
        @members = @group.users
    end


    def edit
        @group = Group.find(params[:id])
        @members = @group.users
    end

    def update
        @group = Group.find(params[:id])
        images_to_attach = params[:group][:images]
        group_data = params.require(:group).permit(:name, user_ids: [])


        if @group.update(group_data)
          if images_to_attach.present?
            @group.images.attach(images_to_attach)
          end
          redirect_to group_path(@group), notice: 'グループを更新しました。'
        else
          render :show, status: :unprocessable_entity
        end
    end


    def destroy
        delete_group = Group.find(params[:id])
        if delete_group.destroy
            redirect_to groups_path, notice: 'グループを削除しました。'
        end
    end

    # --- 追記ここから (public なアクション) ---
    # (destroy アクションの下、 private の上に追加)


    # 1. 招待リンクを表示するページ
    # GET /groups/:id/invitation_link
    def invitation_link
      # @group は before_action でセットされる
      # @token も before_action でセット・保存される
      # (ビュー側で @group.invitation_token を参照する)
    end
 
    # 2. 招待リンクの飛び先（参加確認）ページ
    # GET /groups/:id/join/:token
    def join
      # @group は before_action でセットされる
      @token = params[:token]
     
      # --- バリデーション ---
      # 1. トークンが一致するか
      if @group.invitation_token != @token
        flash[:danger] = "無効な招待リンクです。"
        redirect_to groups_path
      # 2. 既にグループに参加済みか
      elsif @group.joined?(current_user)
        flash[:warning] = "あなたは既にこのグループに参加しています。"
        redirect_to group_path(@group) # グループのshowページへ
      end
      # すべて通れば join.html.erb が表示される
    end
 
    # 3. グループに参加する処理
    # POST /groups/:id/join
    def join_group
      # @group は before_action でセットされる
     
      # --- バリデーション ---
      # 1. トークンが一致するか (フォームから送られた隠しトークン)
      if @group.invitation_token != params[:invitation_token]
        flash[:danger] = "無効な招待リンクです。"
        redirect_to groups_path
      # 2. 既にグループに参加済みか
      elsif @group.joined?(current_user)
        flash[:warning] = "あなたは既にこのグループに参加しています。"
        redirect_to group_path(@group)
      # 3. 参加処理
      else
        # GroupUser (中間テーブル) レコードを作成して、ユーザーをグループに追加
        @group.users << current_user
       
        flash[:success] = "#{@group.name} に参加しました。"
        redirect_to group_path(@group)
      end
    end
     # --- 追記ここまで ---

    
    private
        def set_group
            @group = Group.find(params[:id])
        end


        def group_params
            params.require(:group).permit(:name, user_ids: [], images: [])
        end

        # --- 追記ここから (private なメソッド) ---
        # (group_params の下に追加)


        # :id を使う招待アクション用の set_group
        def set_group_for_invitation
            @group = Group.find(params[:id])
        end
   
        # 招待リンク表示ページを開くたびに、トークンを（再）生成・保存する
        def create_invitation_token
            @group = Group.find(params[:id]) # このアクション用の @group をセット
            @token = Group.new_token
         
          # トークンをDBに保存 (バリデーションをスキップ)
          # update_attribute は非推奨になりつつあるため、update_column を使用
        unless @group.update_column(:invitation_token, @token)
            flash[:danger] = "招待リンクの生成に失敗しました。"
            redirect_to group_path(@group)
        end
        end
        # --- 追記ここまで ---


end
