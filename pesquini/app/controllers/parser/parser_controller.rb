=begin
File: parser_controller.rb
Purpose: Class that manipulate the data to the application.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class Parser::ParserController < ApplicationController

  require 'csv'
  include ParserCheckSave
  include CheckText

  # Authorize filter only with that caracteristics checked.
  before_filter :authorize, only: [:check_nil_ascii, :check_date, :import, 
                                       :build_state, :build_sanction_type, 
                                       :build_enterprise, :build_sanction, 
                                       :check_and_save]

  # 
  # Empty method.
  # 
  # @return 
  def index()

  end

end

  
