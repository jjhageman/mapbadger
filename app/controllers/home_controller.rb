class HomeController < ApplicationController
  include CacheableFlash

  caches_page :index
  def index
    @notification = Notification.new
    render :layout => false
  end

  def create
    @notification = Notification.new(params[:notification])
    if @notification.save
      redirect_to root_path, notice: 'Success. Your email address has been received.'
    else
      flash.now[:error] = 'There was an error saving your email address.'
      render action: 'index', :layout => false
    end
  end
end
