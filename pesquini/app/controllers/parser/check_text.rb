=begin
File: check_text.rb
Purpose: Contains methods to check text and date format.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

module CheckText

  require 'logger'
	
	# 
  # Method that check's for empty ascii caracters in data file.
  # @param text [String] Keeps the string with the upcase form. 
  # 
  # @return [String] Text in upcase form.
  def check_nil_ascii( text )

    Preconditions.check_argument( text ) { is_not_nil }

    if text.include?( "\u0000" )
      text_format = "Não Informado"
    else
      text_format = text.upcase()
    end

    return text_format

  end

  # 
  # Method that check's data date.
  # @param text [String] receives date from parser.
  # 
  # @return [String] text in date format.
  def check_date( text )

    Preconditions.check_argument( text ) { is_not_nil }

    begin
      unless text_date = text.to_date()
        logger.error("Date in wrong format: #{text_date}")
      end
    rescue StandardError::ArgumentError
      logger.error(" #{text_date}: " + Errno::EINVAL)
    end

    return text_date

  end

end




