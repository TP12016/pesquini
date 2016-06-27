=begin
File: payment.rb
Purpose: Class with information on payments process.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class Payment < ActiveRecord::Base

  require 'logger'

  belongs_to :enterprise

  validates_uniqueness_of :process_number

  # 
  # Method that refresh payment searched by process number.
  # 
  # @return [String] result of search.
  def refresh!()

  	Preconditions.check_not_nil( process_number )

    logger.info("finding payment by process number.")

  	# [String] receives search result.
    found_payment = Payment.find_by_process_number( self.process_number )

    logger.debug("payment: #{found_payment} and process number #{process_number}")

    return found_payment

  end

end