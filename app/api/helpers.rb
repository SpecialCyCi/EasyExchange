module APIHelpers

  def warden
    env['warden']
  end

  def authenticated?
    if warden.authenticated?
      return true
    else
      error!({"error" => "Unauth 401"}, 401)
    end
  end

  def current_user
    warden.user
  end

end
