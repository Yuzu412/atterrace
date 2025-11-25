class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      flash[:success] = "コメントしました"
    else
      flash[:alert] = "コメントできませんでした"
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @commentable = find_commentable
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "コメントを削除しました"
    redirect_back(fallback_location: root_path)
  end

  private

  # tweet か blog のどちらのコメントかを判断
  def find_commentable
    if params[:tweet_id]
      Group.find(params[:group_id]).tweets.find(params[:tweet_id])
    elsif params[:blog_id]
      Group.find(params[:group_id]).blogs.find(params[:blog_id])
    else
      raise ActiveRecord::RecordNotFound, "Commentable not found"
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
