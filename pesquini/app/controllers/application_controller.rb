=begin
File: application_controller.rb
Purpose: Raise an exception in case the application doesn't start right.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class ApplicationController < ActionController::Base

  require 'logger'
  include SessionsHelper

=begin
  Prevent CSRF attacks by raising an exception.
  For APIs, you may want to use :null_session instead.
=end
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  rescue_from ActionController::RoutingError, :with => :render_not_found

  # 
  # Send a message in case has a routing problem.
  # 
  # @return exception.
  def raise_not_found!()

    logger.warn("has ocurred a problem in routing.")

    raise ActionController::RoutingError.
          new( "No route matches #{params[:unmatched_route]}" )

  end

  # 
  # Gives an error 404.
  # 
  # @return error 404 in a html page.
  def render_not_found()

    respond_to do |error404|
      logger.info("gives error 404 in html.")
      Preconditions.check_not_nil( error404 )
      error404.html{ render :template => "errors/404", :status => 404 }
    end

  end

  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
