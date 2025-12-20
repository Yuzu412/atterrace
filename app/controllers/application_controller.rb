class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_my_groups
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :show_header?, :show_sidebar?, :show_group_header?
  layout :layout_by_resource

  def show_header?
    controller_name.in?(%w[tweets blogs]) ||
      (controller_name == "groups" && action_name != "new")
  end

  def show_sidebar?
    show_header?
  end

  def show_group_header?
    controller_name == "tweets" ||
      (controller_name == "groups" && !["new", "edit"].include?(action_name)) ||
      controller_name == "blogs"
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :image])
  end

  def after_sign_in_path_for(resource)
    if resource.groups.any?
      resource.groups.last # 最後に使ったグループに飛ばす
    else
      new_group_path # グループがなければ作成ページへ
    end
  end

  def after_update_path_for(resource)
    session.delete(:return_to) || root_path
  end

    def after_update_path_for(resource)
    # 編集ページに来る直前のURL（group_showなど）に戻す
    request.referer || root_path
  end

  def set_my_groups
    if user_signed_in?
      @my_groups = current_user.groups
    end
  end

  private

  def layout_by_resource
    if user_signed_in?
      "logged_in"
    else
      "application"
    end
  end
  
end
