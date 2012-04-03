class ContactController < ApplicationController
  respond_to :html, :json

  def create
    ContactMailer.wish_email(request.referrer, params[:message]).deliver unless params[:message].blank?
  end
end
