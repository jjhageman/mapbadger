class Company < ActiveRecord::Base
  has_many :opportunities
  has_many :representatives
  has_many :territories

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :lockable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
end
