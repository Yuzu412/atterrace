class LikesController < ApplicationController
  before_action :set_likeable

  def create
    @like = current_user.likes.create(likeable: @likeable)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = current_user.likes.find_by(likeable: @likeable)
    @like.destroy if @like
    redirect_back(fallback_location: root_path)
  end

  private

  def set_likeable
    # tweet_id か blog_id のどちらかを params から判定
    if params[:tweet_id]
      @likeable = Tweet.find(params[:tweet_id])
    elsif params[:blog_id]
      @likeable = Blog.find(params[:blog_id])
    else
      raise "Likeable not found"
    end
  end
end