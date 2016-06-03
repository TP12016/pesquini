=begin
File: sanction_type.rb
Purpose: Class to defines the types of sanctions.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class SanctionType < ActiveRecord::Base

  has_many :sanctions
  validates_uniqueness_of :description

  # 
  # Method that refresh enterprises searched by sanction type.
  # 
  # @return [String] sanction description.
  def refresh!()

    Preconditions.check_not_nil( description )

    #  [String] receives sanction description.
    found_sanction_description = SanctionType.find_by_description( self.description )

    return found_sanction_description

  end


  # 
  # Method to informs all the types of sanctions.
  # 
  # @return [String] sanction type.
  def self.all_sanction_types()

    # [String] keeps the sanction type data.
    sanction_types = [
      [ "INIDONEIDADE - LEGISLAçãO ESTADUAL", "Inidoneidade - Legislação Estadual"],
      [ "IMPEDIMENTO - LEI DO PREGãO", "Impedimento - Lei do Pregão"],
      [ "PROIBIçãO - LEI ELEITORAL", "Proibição - Lei Eleitoral"],
      [ "INIDONEIDADE - LEI DE LICITAçõES", "Inidoneidade - Lei de Licitações"],
      [ "SUSPENSãO - LEI DE LICITAçõES","Suspensão - Lei de Impedimento Licitações"],
      [ "SUSPENSãO - LEGISLAçãO ESTADUAL", "Suspensão - Legislação estadual"],
      [ "PROIBIçãO - LEI DE IMPROBIDADE", "Proibição - Lei de improbidade"],
      [ "DECISãO JUDICIAL LIMINAR/CAUTELAR QUE IMPEçA CONTRATAçãO",
      	"Decisão Judicial liminar"],
      [ "INIDONEIDADE - LEI DA ANTT E ANTAQ ", "Inidoneidade - Lei da ANTT e ANTAQ"],
      [ "INIDONEIDADE - LEI ORGâNICA TCU", "Inidoneidade - Lei Orgânica TCU"],
      [ "IMPEDIMENTO - LEGISLAçãO ESTADUAL", "Impedimento - Legislação Estadual"],
      [ "SUSPENSãO E IMPEDIMENTO - LEI DE ACESSO à INFORMAçãO",
      	"Suspensão e Impedimento - Lei de Acesso à Informação"],
      [ "PROIBIçãO - LEI ANTITRUSTE", "Proibição - Lei Antitruste"],
      [ "IMPEDIMENTO - LEI DO RDC", "Impedimento - Lei do RDC"],
      [ "PROIBIçãO - LEI AMBIENTAL", "Proibição - Lei Ambiental" ],
    ]

    return sanction_types

  end

end