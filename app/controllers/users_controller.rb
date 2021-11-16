class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy
                                          following followers)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
   load_user_or_redirect
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = t "welcome_message", username: @user.name
      flash[:danger] = t "active_danger"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    load_user_or_redirect
  end

  def update
    load_user_or_redirect
    if @user.update(user_params)
      flash[:success] = t "Profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    load_user_or_redirect
    if user&.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find_by(id: params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.find_by(id: params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
                                 :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "login"
    redirect_to login_url
  end

  def correct_user
    load_user_or_redirect
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user_or_redirect
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:warning] = t "user_not_found"
    redirect_to login_url
  end
end
