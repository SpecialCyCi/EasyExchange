module APIHelpers

  def authenticated?
    if !params[:auth_token].blank? && !current_user.blank?
      return true
    end
    error!({ "error" => "Unauthorized" }, 401)
  end

  def current_user
    return @current_user if !@current_user.blank?
    @current_user = User.where(authentication_token: params[:auth_token]).first
    @current_user
  end

end
