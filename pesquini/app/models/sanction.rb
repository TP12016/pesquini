=begin
File: sanction.rb
Purpose: Class with information of sanctions by year.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

PERCENTAGE = 100

class Sanction < ActiveRecord::Base

  require 'logger'

  # Associate sanction with enterprise, sanction type and state.
  belongs_to :enterprise, counter_cache: true
  belongs_to :sanction_type
  belongs_to :state

  validates_uniqueness_of :process_number

  scope :by_year, lambda { |year| where( "extract(year from initial_date) = ?", year ) }

  #
  # Method that define all years that have sanctions on data.
  #
  # @return [String] years.
  def self.all_years()

    logger.info("define years with sanctions. Method self.all_years(). File sanction.rb")
    
    years = ["All", 1988, 1991, 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002,
             2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013,
             2014, 2015]

    Preconditions.check_not_nil( years )

    logger.debug("years with sanctions")

    return years

  end

  #
  # Method that refresh sanctions searched by process number.
  #
  # @return [String] result of search.
  def refresh!()

    logger.info("refresh sanctions. Method refresh!(). File sanction.rb")

    Preconditions.check_not_nil( process_number )

    # keeps the sanction finded by process.
    found_sanction = Sanction.find_by_process_number( self.process_number )

    logger.debug("sanction: #{found_sanction} and process number")

    return found_sanction
  end

  #
  # Method for calculating the percentage of sanctions.
  # @param value [Double] receives a percentage of the total value.
  #
  # @return [Double] percentage.
  def self.percentual_sanction( value )

    logger.info("calculate sanction percentage. Method percentual_sanction(). File sanction.rb")

    # [Interger] receives the full amount.
    total = Sanction.all.count

    Preconditions.check( total ) { is_not_nil and has_type( Interger ) and
                                                          satisfies("> 0") { total > 0 } }

    # Verify value result and raise an exception in case is in wrong format.
    begin
      unless value = value * PERCENTAGE / total

        Preconditions.check( value ) { is_not_nil and has_type( Double ) }

        logger.error("Value in wrong format: #{value}")
      end
    rescue StandardError::ArgumentError
      logger.error(" #{value}: " + Errno::EINVAL)
    end

    return value

  end

end