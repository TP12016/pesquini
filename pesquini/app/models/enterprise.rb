=begin
File: enterprise.rb
Purpose: Class that search, sort and ranking enterprises by position and sanction.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class Enterprise < ActiveRecord::Base

  require 'logger'

  has_many :sanctions
  has_many :payments
  validates_uniqueness_of :cnpj

  scope :featured_sanctions, -> ( number = nil ){number ? order( "sanctions_count DESC" )
                                              .limit( number ) :order('sanctions_count DESC') }
  scope :featured_payments, -> ( number = nil ){number ? order( "payments_sum DESC" )
                                              .limit( number ) :order( "payments_sum DESC" ) }

  #
  # Method that informs the last penalty.
  #
  # @return [String] last searched sanction.
  def last_sanction()

    logger.info("informing last sanction.")

    # Receives last sanction.
    sanction = self.sanctions.last

    unless sanction.nil?()
      self.sanctions.each do |searched_sanction|

        # This block will compare the initial and last dates of the sanctions,
        # And making the last date, a new variable.
        Preconditions.check_not_nil( searched_sanction )
        if searched_sanction.initial_date > sanction.initial_date
          sanction = searched_sanction
        else
          logger.warn("didnt found sanction.")
        end
      end
    end

    return sanction

  end

  #
  # Method that informs the last payment received.
  #
  # @return [String] last payment received.
  def last_payment()

    # [String] Receives last payment received by an enterprise.
    payment = self.payments.last()

    unless payment.nil?()
      self.payments.each do |searched_payment|

        logger.info("payment #{payment} can't be nil.")

        # This block will compare the researched payment amount on date,
        # And making the last payment, a new variable.
        Preconditions.check_not_nil( searched_payment )
        if searched_payment.sign_date > payment.sign_date
          payment = searched_payment
        else
          logger.warn("didnt found payment.")
        end
      end
    end

    return payment

  end

  #
  # Method that tells whether there were payments after a penalty.
  #
  # @return
  def payment_after_sanction?()

    # [String] Receives last sanction.
    sanction = last_sanction

    # [String] Receives last payment received by an enterprise.
    payment = last_payment

    logger.info("comparing enterprise payment day.")

    # This block will compare if a enterprise received a payment 
    # after initial date of sanction, return payment value.
    if sanction && payment
      payment.sign_date < sanction.initial_date
    else
      false
    end

    return payment

  end

  #
  # Method that refresh enterprises searched by CNPJ.
  #
  # @return [String] result of search.
  def refresh!()

    Preconditions.check_not_nil( cnpj )

    # [String] keep enterprise searched.
    searched_enterprise = Enterprise.find_by_cnpj( self.cnpj )

    logger.debug("search enterprise by cnpj #{searched_enterprise}")

    return searched_enterprise

  end

  #
  # Method that organizes the companies position amount of sanctions.
  # @param enterprise [String] keeps a enterprise.
  #
  # @return enterprise by its position.
  def self.enterprise_position( enterprise )

    Preconditions.check_not_nil( enterprise )

    # [String] keep features sanctions ordered.
    orderedSanc = self.featured_sanctions

    # [String] order sanctions in group.
    groupedSanctions_uniqueness = orderedSanctions.uniqueness()
    groupedSanctions = groupedSanctions_uniqueness.group_by( &:sanctions_count ).to_a

    # Organize sanctions by group.
    groupedSanctions.each_with_index do |quantity_sanctions, index|

      Preconditions.check_not_nil( quantity_sanctions )
      Preconditions.check( index ) {has_type( Integer ) and
                                                satisfies( ">= 0" ) { index >= 0 }}

      # Count enterprises sanctions.
      if quantity_of_sanctions[0] == enterprise.sanctions_count
        return index + 1
      else
        logger.info("enterprise without sanction.")
      end
    end

  end

  #
  # Method shows that the most sanctioned companies to build a ranking.
  #
  # @return [String] a list with the enterprises with more sanctions.
  def self.most_sanctioned_ranking()

    enterprise_group = []
    enterprise_group_count = []
    @enterprise_group_array = []

    logger.info("sorting sanctions by ranking.")

    # [String] sort sanctions counted.
    sorted_sanctions = Enterprise.all.sort_by{
              |quantity_of_sanctions_ranking| quantity_of_sanctions_ranking.sanctions_count }

    Preconditions.check_not_nil( sorted_sanctions )

    # [String] reverse sort.
    uniqueness = sorted_sanctions.uniq
    sorted_group_sanctions = uniqueness.group_by( &:sanctions_count )
    sorted_group_sanctions_reverse = sorted_group_sanctions.to_a.reverse

    Preconditions.check_not_nil( sorted_group_sanctions )

    # Sort sanctions in groups.
    sorted_group_sanctions.each do |quantity_group_sanctions|

      logger.info("sorting sanctions in groups.")
      
      enterprise_group << quantity_group_sanctions[0]
      enterprise_group_count << quantity_group_sanctions[1].count
    end

    @enterprise_group_array << enterprise_group
    @enterprise_group_array << enterprise_group_count

    return @enterprise_group_array

  end

end
