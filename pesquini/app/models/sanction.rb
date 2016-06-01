=begin
File: sanction.rb
Purpose: Class with information of sanctions by year.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

PERCENTAGE = 100

class Sanction < ActiveRecord::Base

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

    Preconditions.check_not_nil( years )
    years = ["All", 1988, 1991, 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002,
             2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013,
             2014, 2015]
    return years

  end

  #
  # Method that refresh sanctions searched by process number.
  #
  # @return [String] result of search.
  def refresh!()

    Preconditions.check_not_nil( process_number )

    # keeps the sanction finded by process.
    found_sanction = Sanction.find_by_process_number( self.process_number )

    return found_sanction
  end

  #
  # Method for calculating the percentage of sanctions.
  # @param value [Double] receives a percentage of the total value.
  #
  # @return [Double] percentage.
  def self.percentual_sanction( value )

    Preconditions.check( total ) { is_not_nil and has_type( Interger ) and
                                                          satisfies("> 0") { total > 0 } }
    Preconditions.check( value ) { is_not_nil and has_type( Double ) }

    # [Interger] receives the full amount.
    total = Sanction.all.count

    value = value * PERCENTAGE / total

    return value

  end

end