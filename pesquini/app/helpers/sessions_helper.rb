=begin
File: sessions_helper.rb
Purpose: Module that contains login verification method.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

module SessionsHelper

  require 'logger'

  #
  # Method with user login information.
  # @param user [String] contains session user login information.
  #
  # @return [String] current user logged.
  def sign_in( user )

    logger.info("login user.")

    Preconditions.check_not_nil( user )

    # Log user in application verifying the token.
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute( :remember_token, User.digest( remember_token ) )
    self.current_user = user

    logger.debug("current user in application #{current_user}")

    return current_user

    end

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

    # [String] receives user password.
    remember_token = User.digest( cookies[:remember_token] )

    @current_user ||= User.find_by( remember_token: remember_token )

    return @current_user

  end

  #
  # Check's if signed user is not null.
  #
  # @return [String] not null user.
  def signed_in?()

    begin
      !current_user.nil?
    rescue
      logger.fatal("logged user is nil #{current_user}")
    end

    return current_user

  end


  #
  # Method that check user logged.
  #
  # @return [String] alert message in case user is no authorized.
  def authorize()

    unless signed_in?
      redirect_to "/signin'" alert: "Not authorized!"
      logger.error("user is not authorized #{alert:}")
    end
  end

  #
  # Method to end session.
  #
  # @return [String] null user.
  def sign_out()

    logger.info("ending session.")

    # Log out user by deleting session token.
    current_user.update_attribute( :remember_token,
    User.digest( User.new_remember_token ) )
    cookies.delete( :remember_token )
    self.current_user = nil

    logger.debug("user sign out have to be nil #{current_user}")

    return current_user

  end

end

