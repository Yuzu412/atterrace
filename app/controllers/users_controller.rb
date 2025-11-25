class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) 
    @last_group = Group.find_by(id: session[:last_group_id])
  end
end
