class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new;end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "notify_info"
      redirect_to root_url
    else
      flash.now[:danger] = t "notify_danger_create"
      render :new
    end
  end

  def edit;end

  def update
    if user_params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update_attributes user_params
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    return if(@user && @user.activated? &&@user.authenticated?(:reset, params[:id]))
    redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "notify_danger_check_expiration"
      redirect_to new_password_reset_url
  end
end
