class Company < ActiveRecord::Base
  ROLES = %w[admin banned]

  has_many :opportunities
  has_many :representatives
  has_many :territories
  has_many :csvs

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :company_name, :first_name, :last_name, :phone, :company_size,
                  :email, :password, :password_confirmation, :remember_me
  
  def admin?
    role == 'admin'
  end  
end
