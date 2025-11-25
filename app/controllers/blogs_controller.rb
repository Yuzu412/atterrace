class BlogsController < ApplicationController
  before_action :set_group  # すべてのアクションでグループ情報を取得

  def index
    @blogs = @group.blogs
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"

    @spring_blogs = @blogs.select { |b| [3, 4, 5].include?(b.created_at.month) }
    @summer_blogs = @blogs.select { |b| [6, 7, 8].include?(b.created_at.month) }
    @autumn_blogs = @blogs.select { |b| [9, 10, 11].include?(b.created_at.month) }
    @winter_blogs = @blogs.select { |b| [12, 1, 2].include?(b.created_at.month) }
  end

  def new
    @blog = @group.blogs.new
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
  end

  def show
    @group = Group.find(params[:group_id])
    @blog = @group.blogs.find(params[:id])
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
    @comments = @blog.comments
    @comment = Comment.new
  end

  def create
    @blog = @group.blogs.new(blog_parameter)
    @blog.user = current_user
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
    if @blog.save
      redirect_to group_blogs_path(@group), notice: "投稿しました"
    else
      render :new
    end
  end

  def destroy
    @blog = @group.blogs.find(params[:id])
    @blog.destroy
    redirect_to group_blogs_path(@group), notice: "削除しました"
  end

  def edit
    @blog = @group.blogs.find(params[:id])
    @members = @group.users
    @group_lists = Group.all
    @group_joining = GroupUser.where(user_id: current_user.id)
    @group_lists_none = "グループに参加していません。"
  end

  def update
    @blog = @group.blogs.find(params[:id])
    if @blog.update(blog_parameter)
      redirect_to group_blogs_path(@group), notice: "編集しました"
    else
      render :edit
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def blog_parameter
    params.require(:blog).permit(:title, :content, :start_time, :image)
  end
end
