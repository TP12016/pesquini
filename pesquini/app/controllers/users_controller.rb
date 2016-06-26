=begin
File: user_controller.rb
Purpose: Class responsible ti create new user.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class UsersController < ApplicationController

  require 'logger'
  
  # 
  # Method that create a new user.
  # 
  # @return new user.
  def new()

  	Preconditions.check_not_nil( @user )

  	# [String] Keeps new user created.
    @user = User.new()

    logger.debug("create new user #{@user}")

    return @user

  end

end
