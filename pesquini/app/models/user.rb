=begin
File: user.rb
Purpose: Class that validates new User.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class User < ActiveRecord::Base

  has_secure_password

  # responsible for receiving the validation information.
  validates :login, length: { maximum: 50, minimum: 5 }, 
	                uniqueness: { case_sensitive: false }, allow_blank: false
  validates :password, length: { minimum: 8 }, allow_blank: false

  # 
  # Method that generates a random token for password recovery.
  # 
  # @return [String] token for password.
  def User.new_remember_token()

  	return SecureRandom.urlsafe_base64

  end
  	
  # 
  # Method that compile token.
  # @param token [String] keeps generated token.
  # 
  # @return [String] digest SHA1 to string.
  def User.digest( token )

    return Digest::SHA1.hexdigest( token.to_s )
  
  end

end