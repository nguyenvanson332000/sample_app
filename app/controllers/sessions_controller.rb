class SessionsController < ApplicationController
  def new; end

  def create
    session_params = params[:session]
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      handle_authenticated session_params
    else
      flash.now[:danger] = t "login_invalid"
      render :new
    end
  end

  def handle_authenticated session_params
    if user.activated
      log_in user, session_params[:remember_me]
      flash[:success] = t "welcome_message", username: user.name
      redirect_back_or user
    else
      flash[:warning] = t "active_message"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
