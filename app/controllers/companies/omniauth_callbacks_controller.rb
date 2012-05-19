class Companies::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def salesforce
    @company = Company.find_for_salesforce_oauth(request.env["omniauth.auth"])

    if @company.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Salesforce"
      sign_in_and_redirect @company, :event => :authentication
    else
      session["devise.salesforce_data"] = request.env["omniauth.auth"]
      redirect_to new_company_registration_url
    end
  end
end
