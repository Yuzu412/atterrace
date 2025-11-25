class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

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
end
