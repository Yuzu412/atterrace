class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group


  def new
    @tweet = @group.tweets.new
  end

def create
  @tweet = @group.tweets.new(tweet_params)
  @tweet.user = current_user

  if @tweet.save
    redirect_to group_path(@group)  # ← 1回だけ
  else
    render :new, status: :unprocessable_entity
  end
end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments
    @comment = Comment.new
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
  end

  def edit
    @tweet = Tweet.find(params[:id])
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
  end

  def update
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "show", :id => tweet.id
    else
      redirect_to :action => "new"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])
    @tweet = @group.tweets.find(params[:id])

    @tweet.destroy
    redirect_to group_path(@group), notice: "削除しました"
  end

  private
  def tweet_params
    params.require(:tweet).permit(:body, images: [])
  end

  def set_group
    @group = Group.find(params[:group_id])
    session[:last_group_id] = @group.id
  end


end
