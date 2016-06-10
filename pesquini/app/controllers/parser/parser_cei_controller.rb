=begin
File: parser_cei_controller.rb
Purpose: Class that treats the parser data from file CEIS.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class Parser::ParserCeiController < Parser::ParserController

  require 'csv'
  include ParserCheckSave
  include CheckText
  require 'logger'

  # Keeps the .csv file.
  @@filename = 'parser_data/CEIS.csv'

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
  # Method that import data from .csv file.
  #
  # @return [String] sanction object.
  def import()

    CSV.foreach( @@filename, :headers => true, :col_sep => "\t",
                 :encoding => 'ISO-8859-1' ) do |row|

      logger.info("importing CSV content")

      Preconditions.check_not_nil( data )
      data = row.to_hash
      if not data["Tipo de Pessoa"].match( "J|j" ).nil?()

        Preconditions.check_not_nil( sanction_type )

        # [String] Keeps the sanction type data.
        sanction_type = build_sanction_type( data )

        Preconditions.check_not_nil( state )

        # [String] Keeps the state data.
        state = build_state( data )

        Preconditions.check_not_nil( enterprise )

        # [String] Keeps the enterprise data.
        enterprise = build_enterprise( data )

        build_sanction( data, sanction_type, state, enterprise )

      end
    end

  end

  #
  # Method that take and create the state.
  # @param row_data [String] Keeps the state data from CEI.
  #
  # @return [String] Save the new state created.
  def build_state( row_data )

    logger.info("building state")
    Preconditions.check_argument( row_data ) { is_not_nil }
    Preconditions.check_not_nil( new_state )

    # [String] Keeps the new state created.
    new_state = State.new()

    new_state.abbreviation = check_nil_ascii( row_data["UF Órgão Sancionador"] )

    check_and_save( new_state )

    return new_state

  end

  #
  # Method that take and create the sanction.
  # @param row_data [String] Keeps sanction type data from CEI.
  #
  # @return [String] Save new_sanction_type created.
  def build_sanction_type( row_data )

    Preconditions.check_argument( row_data ) { is_not_nil }
    Preconditions.check_not_nil( new_sanction_type )

    # [String] Keeps the new sanction type created.
    new_sanction_type = SanctionType.new()

    new_sanction_type.description = check_nil_ascii( row_data["Tipo Sanção"] )
    check_and_save( new_sanction_type )

    return new_sanction_type

  end

  #
  # Method that take and create the the enterprise.
  # @param row_data [String] Keeps enterprise data from CEI.
  #
  # @return [String] Save new enterprise created.
  def build_enterprise( row_data )

    Preconditions.check_argument( row_data ) { is_not_nil }
    Preconditions.check_not_nil( new_enterprise )

    # [String] Keeps the new enterprise created.
    new_enterprise = Enterprise.new()

    new_enterprise.cnpj = row_data["CPF ou CNPJ do Sancionado"]
    new_enterprise.corporate_name = check_nil_ascii( row_data["Razão Social - Cadastro Receita"] )
    check_and_save( new_enterprise )

    return new_enterprise

  end

  #
  # Method that create sanction.
  # @param row_data [String] Keeps sanction data from CEI.
  # @param sanction_type [String] Contain information from sanction type created.
  # @param state [String] Contain information from state created.
  # @param enterprise [String] Contain information from enterprise type created.
  #
  # @return [String] Save new sanction created.
  def build_sanction( row_data, sanction_type, state, enterprise )

    logger.info("building sanction object")

    Preconditions.check_argument( row_data, sanction_type, state, enterprise ) { is_not_nil }
    Preconditions.check_not_nil( new_sanction )

    # [String] Keeps information for sanction created.
    new_sanction = Sanction.new()

    # Takes sanction values to build new sanction.
    new_sanction.initial_date = check_date( row_data["Data Início Sanção"] )
    new_sanction.final_date = check_date( row_data["Data Final Sanção"] )
    new_sanction.process_number = check_nil_ascii( row_data["Número do processo"] )
    new_sanction.enterprise_id = enterprise.id
    new_sanction.sanction_type_id = sanction_type.id
    new_sanction.sanction_organ = check_nil_ascii( row_data["Órgão Sancionador"] )
    new_sanction.state_id = state.id
    check_and_save( new_sanction )

    return new_sanction

  end

end
