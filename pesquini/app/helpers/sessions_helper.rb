=begin
File: sessions_helper.rb
Purpose: Module that contains login verification method.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

module SessionsHelper

  # 
  # Method with user login information.
  # @param user [String] contains session user login information.
  # 
  # @return [String] current user logged.
  def sign_in( user )

    Preconditions.check_not_nil( user )

    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute( :remember_token, User.digest( remember_token ) )
    self.current_user = user

    return current_user

  end

  # 
  # @deprecated  Method to return current user.
  # @param user [String] contains session user login information.
  # 
  # @return [String] user logged.
  def current_user=( user )

    Preconditions.check_not_nil( user )
    @current_user = user

  end

  # 
  # Method to find user by password.
  # 
  # @return [String] found user.
  def current_user()

    remember_token = User.digest( cookies[:remember_token] )
    @current_user ||= User.find_by( remember_token: remember_token )

    return @current_user

  end


  # 
  # Check's if signed in user is not null.
  # 
  # @return [String] not null user.
  def signed_in?()

    !current_user.nil?

    return current_user

  end


  # 
  # Method that check user logged.
  # 
  # @return [String] alert message in case user is no authorized.
  def authorize()

    redirect_to '/signin', alert: "Nao autorizado !" unless signed_in?   
    
  end

  # 
  # Method to end session.
  # 
  # @return [String] null user.
  def sign_out()

    current_user.update_attribute( :remember_token, 
    User.digest( User.new_remember_token ) )
    cookies.delete( :remember_token )
    self.current_user = nil

    return current_user
    
  end

end

