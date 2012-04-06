class ContactController < ApplicationController
  before_filter :authenticate_company!
  respond_to :html, :json

  def create
    ContactMailer.wish_email(request.referrer, current_company.email, params[:message]).deliver unless params[:message].blank?
  end
end
