=begin
File: enterprise_controller.rb
Purpose: Class that manipulates enterprises data.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class EnterprisesController < ApplicationController

  # 
  # Give result form enterprise search.
  # 
  # @return [String] enterprises.
  def index()

    if params[:q].nil?()

      @search = Enterprise.search( params[:q].try( :merge, m: 'or' ) )
      @enterprises = Enterprise.paginate( :page => params[:page], :per_page => 10 )
    else
      params[:q][:cnpj_eq] = params[:q][:corporate_name_cont]
      @search = Enterprise.search( params[:q].try( :merge, m: 'or' ) )
      @enterprises = @search.result.paginate( :page => params[:page], :per_page => 10 )
    end

    return @enterprises

  end

  #
  # Method to show enterprises attributes.
  #
  # @return [String] enterprise attributes.
  def show()

    # [Integer] keeps number of enterprises search result per page.
    @per_page = 10

    # Build enterprises values to show per page.
    @page_number = show_page_number()
    @enterprise = Enterprise.find( params[:id] )
    @collection = Sanction.where( enterprise_id: @enterprise.id )
    @payments = Payment.where( enterprise_id: @enterprise.id )
    @payments_per_page = @payments.paginate( :page => params[:page], :per_page => @per_page )
    @sanctions = @collection.paginate( :page => params[:page], :per_page => @per_page )
    @payment_position = enterprise_payment_position( @enterprise )
    @position = Enterprise.enterprise_position( @enterprise )

    return @position

  end

  #
  # Method to show the page number.
  #
  # @return [ Integer ] page number.
  def show_page_number()  

    if params[:page].to_i > 0
      @page_number = params[:page].to_i  - 1
    else
      @page_number = 0
    end

    return @page_number

  end

  # 
  # Method that manipulates the payments to the enterprise.
  # @param enterprise [String] keeps enterprises information.
  # 
  # @return [String] position of most payment enterprises.
  def enterprise_payment_position( enterprise )

    # [String] receives enterprises payments.
    payment_position = Enterprise.featured_payments

    payment_position.each_with_index do |total_sum, index|

      # Raise an exception in case total sum is nil.
      if total_sum.nil?
        raise "total_sum should not be nil" 
      end

      payments_sum(total_sum, enterprise)      
    end

    return payment_position

  end

  # 
  # Give the next payment position.
  # @param total_sum [String] keeps the sum of payments.
  # @param enterprise [String] keeps the enterprise.  
  # 
  # @return [Integer] enterprise position according to the payment received.
  def payments_sum( total_sum, enterprise )

    Preconditions.check( index ) { index >= 0 }
    
    # Verify if enterprise payment sum is equal total sum. 
    if total_sum.payments_sum == enterprise.payments_sum
      return index + 1
    else
      # Nothing to do.
    end

  end 

end
