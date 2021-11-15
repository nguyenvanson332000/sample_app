class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t "micropost_create_success"
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      redirect_to root_url
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_destroy_success"
    else
      flash[:danger] = t "micropost_destroy_danger"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "not_permit"
    redirect_to root_url?
  end
end
