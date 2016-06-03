=begin
File: parser_cei_controller.rb
Purpose: Contains method to check and save parser information.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

module ParserCheckSave

  # 
  # Method that check and save parser information.
  # @param check [String] Use to check content.
  # 
  # @return [String] Save the content after it has been checked.
  def check_and_save( check )

    Preconditions.check_argument( check ) { is_not_nil }

    begin
      check.save!
      check
    rescue ActiveRecord::RecordInvalid
      check = check.refresh!
      check
    end
    
  end
  
end

