class User < ApplicationRecord
  has_secure_password

  has_many :secrets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_secrets, through: :likes, source: :secret

  validates :name, :email, presence: true
  validates :password, presence: {on: :create}
  validates :email, uniqueness: {on: :create}, 
          format: {with: URI::MailTo::EMAIL_REGEXP, message: "only allows valid emails"}

  before_save :lowercase_email

  def lowercase_email
    self.email.downcase!
  end
end
