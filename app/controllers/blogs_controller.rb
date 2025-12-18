class BlogsController < ApplicationController
  before_action :set_group  # すべてのアクションでグループ情報を取得

  SEASONS = %w[spring summer autumn winter]

  # --- 季節ページ ---
  def season
    season = params[:season]
    render_season(season)
  end

  # --- 通常の CRUD ---
  def index
    @blogs = @group.blogs
    set_common_variables
    set_season_blogs
  end

  def new
    @blog = @group.blogs.new
    set_common_variables
  end

  def show
    @blog = @group.blogs.find(params[:id])
    set_common_variables
    @comments = @blog.comments
    @comment = Comment.new
  end

  def create
    @blog = @group.blogs.new(blog_parameter)
    @blog.user = current_user
    set_common_variables
    if @blog.save
      redirect_to season_group_blogs_path(@group, season: "spring"), notice: "投稿しました"
    else
      render :new
    end
  end

  def edit
    @blog = @group.blogs.find(params[:id])
    set_common_variables
  end

  def update
    @blog = @group.blogs.find(params[:id])
    if @blog.update(blog_parameter)
      redirect_to group_blog_path(@group, @blog), notice: "更新しました！"
    else
      render :edit
    end
  end

  def destroy
    @blog = @group.blogs.find(params[:id])
    @blog.destroy
    redirect_to season_group_blogs_path(@group, season: "spring"), notice: "削除しました"
  end

  private

  # --- 共通処理 ---
  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_common_variables
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
  end

  def blog_parameter
    params.require(:blog).permit(:title, :content, :start_time, :image)
  end

  # --- 季節ページ用 ---
  def render_season(season)
    @season = season

    months =
      case season
      when "spring" then [3, 4, 5]
      when "summer" then [6, 7, 8]
      when "autumn" then [9, 10, 11]
      when "winter" then [12, 1, 2]
      else []
      end

    @blogs = @group.blogs.select { |b| months.include?(b.created_at.month) }

    # 左右矢印用
    idx = SEASONS.index(season)
    @prev_season = SEASONS[(idx - 1) % SEASONS.length]
    @next_season = SEASONS[(idx + 1) % SEASONS.length]

    set_common_variables
    render :season
  end

  def set_season_blogs
    @spring_blogs = @blogs.select { |b| [3, 4, 5].include?(b.created_at.month) }
    @summer_blogs = @blogs.select { |b| [6, 7, 8].include?(b.created_at.month) }
    @autumn_blogs = @blogs.select { |b| [9, 10, 11].include?(b.created_at.month) }
    @winter_blogs = @blogs.select { |b| [12, 1, 2].include?(b.created_at.month) }
  end
end