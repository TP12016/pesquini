=begin
File: session_controller.rb
Purpose: Class that permit login and logout the system.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class SessionsController < ApplicationController

  require 'logger'

  #
  # Method that create a session.
  #
  # @return logged status.
  def create()

    Preconditions.check_not_nil( login )
    Preconditions.check_not_nil( password )
    Preconditions.check_not_nil( user )

    logger.info("creating session by authenticating user with login and password.")

    # [String] Receive the parameters to login.
    login = params[:session][:login].downcase

    # [String] Keep a password for a determined login.
    password = params[:session][:password]

    # [String] Keep the logged user.
    user = User.find_by( login: login )

    # Sign in user by login and password.
    if user && user.authenticate( password )
      logger.debug("authentication worked.")
      sign_in user
      redirect_to root_path
    else
      logger.error("authentication failed.")
      flash[:error] = "Invalid login or password!"
      logger.debug("will try login again.")
      render :new
    end

  end

  #
  # Method that destroy the session.
  #
  # @return loggout status.
  def destroy()

    assert user.empty?, "User must not be empty to logout!"
    if signed_in?()
      logger.info("logout user.")
      sign_out
      redirect_to root_path
    else
      logger.error("session didnt destroy properly.")
    end

  end

end
