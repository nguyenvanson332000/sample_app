module SessionsHelper
  def log_in user, remember_me
    session[:user_id] = user.id
    remember user if remember_me == "1"
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def remember user
    user.remember_me
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated?(cookies[:remember_token])
        log_in user, false
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
