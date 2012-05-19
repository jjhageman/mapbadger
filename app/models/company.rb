class Company < ActiveRecord::Base
  ROLES = %w[admin banned]

  has_many :opportunities
  has_many :representatives
  has_many :territories
  has_many :csvs

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :company_name, :first_name, :last_name, :phone, :company_size,
                  :email, :password, :password_confirmation, :remember_me
  
  def self.find_for_salesforce_oauth(token)
    data = token.info
    if user = self.find_by_email(data.email)
      user
    else
      user = self.new(:email => data.email, :password => Devise.friendly_token[0,20], :first_name => data.first_name, :last_name => data.last_name)
      user.skip_confirmation!
      user.save
      user
    end
  end

  def self.new_with_session(params, session)
    super.tap do |company|
      if data = session["devise.salesforce_data"] && session["devise.salesforce_data"]["info"]
        company.email = data["email"]
      end
    end
  end

  def admin?
    role == 'admin'
  end

  def first_login?
    sign_in_count == 1
  end
end
