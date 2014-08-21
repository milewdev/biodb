class User < ActiveRecord::Base
  
  validates :email,
    presence: true,
    email_format: true,
    uniqueness: { case_sensitive: false }
    
  validates :password,
    password_format: true
    
  has_secure_password
  
end
