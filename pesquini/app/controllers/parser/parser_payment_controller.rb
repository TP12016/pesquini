=begin
File: parser_payment_controller.rb
Purpose: Class that checks the payment of the enterprises in the site with the file.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class Parser::ParserPaymentController < Parser::ParserController

  require 'csv'
  require 'logger'
  require 'open-uri'
  include CheckAndSave

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
  
  # 
  # This method recieves a string representing a payment value in the format 19,470.99.
  # Then it takes off the comma (",") and parse it to float format as 19470.99.
  # @param text [String] Keeps the string with the new format.
  # 
  # @return [String] String in new format.
  def check_value( text )

    # Verify text value and raise an exception in case is in wrong format.
    begin
      unless text = text.gsub( ",", " " ).to_f()
        logger.error("Payment value in wrong format: #{text}")
      end
    end  
    rescue StandardError::ArgumentError
      logger.error(" #{text}: " + Errno::EINVAL)
    end

    return text

  end

  # 
  # Import the data from the site. 
  # 
  # @return [String] Enterprises without payment.
  def import()

    constante = 0

    Enterprise.find_each() do |enterprise|

      Preconditions.check_not_nil( url )

      # [String] Keeps the url from site that has contratos.csv file.
      url = 'http://compras.dados.gov.br/contratos/v1/contratos.csv?cnpj_contratada='

      begin
        Preconditions.check_not_nil( cnpj )

        # [String] Open url and enterprise cnpj and read it.
        data =  open( url + enterprise.cnpj ).read()

        # [String] Parser the CSV.
        csv = CSV.parse( data, :headers => true, :encoding => 'ISO-8859-1' )

        # Calls method that creates new payment. 
        csv()

      rescue
        constante = constante + 1
      end
    end

    puts "=" * 50
    puts "Quantidade de empresas sem pagamentos: ", constante

  end

  # 
  # Creates new payment object
  # 
  # @return [String] created payment.
  def csv()

    csv.each_with_index() do |row, i|

      assert row.empty?, "row must not be empty!"

      # [String] keeps payment created.
      payment = Payment.new()
          
      # Puts the payment values in the especified row to create new payment object.
      payment.identifier = check_nil_ascii( row[0] )
      payment.process_number = check_nil_ascii( row[10] )
      payment.initial_value = check_value( row[16] )
      payment.sign_date = check_date( row[12] )
      payment.start_date = check_date( row[14] )
      payment.end_date = check_date( row[15] )
      payment.enterprise = enterprise
      enterprise.payments_sum = enterprise.payments_sum + payment.initial_value
      check_and_save( enterprise )
      check_and_save( payment )

      return payment
    end
  end
  
end
