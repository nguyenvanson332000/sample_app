class SessionsController < ApplicationController
  def new; end

  def create
    session_params = params[:session]
    user = User.find_by(email: session_params[:email].downcase)
    if user&.authenticate(session_params[:password])
      log_in user, session_params[:remember_me]
      flash[:success] = t "welcome_message", username: user.name
      redirect_back_or usermain
    else
      flash.now[:danger] = t "login_invalid"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
