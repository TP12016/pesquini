=begin
File: state.rb
Purpose: Class that validates state abbreviation.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class State < ActiveRecord::Base

  require 'logger'

  has_many :sanctions
  validates_uniqueness_of :abbreviation

  # 
  # Method that refresh state.
  # 
  # @return [String] found state.
  def refresh!()

    Preconditions.check_not_nil( abbreviation )
    found_state_abbreviaton = State.find_by_abbreviation( self.abbreviation )

    logger.debug("state by abbreviation #{found_state_abbreviaton}")

    return found_state_abbreviaton

  end

  # 
  # Method that defines all states abbreviation.
  # 
  # @return [String] state abbreviation.
  def self.all_states()

    states_abbreviation = ["BA", "DF", "RJ", "PA", "MG", "SP", "AM", "RS", "SC", "ES", "PR",
              "PB", "RN", "CE", "AL", "RR", "SE", "RO","PI" , "AC",
              "TO", "GO", "PE", "AP", "MS", "MT", "MA", "Não Informado"]

    logger.debug("states abbreviation #{states_abbreviation}")

    return states_abbreviation

  end

end