=begin
File: statistics_controller.rb
Purpose: Contains results of all search method.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class StatisticsController < ApplicationController

  require 'logger'

  # [String] Keeps list of all states.
  @@states_list = State.all_states

  # [String] Keeps all years that have sanction.
  @@sanction_years = Sanction.all_years

  # [String] Keeps sanction type list.
  @@sanction_type_list = SanctionType.all_sanction_types

  def  index()

  end

  #
  # Ranking companies according to the amount of sanctions.
  #
  # @return array of groups with the same amount of sanctions.
  def most_sanctioned_ranking()

    # [String] keeps ranking of enterprises with most sanctions.
    enterprise_group_array = Enterprise.most_sanctioned_ranking()

    # [String] keeps array of enterprises.
    @enterprise_group = enterprise_group_array[0]

    # [String] keeps counting of enterprises group.
    @enterprise_group_count = enterprise_group_array[1]

    return @enterprise_group_count

    assert @enterprise_group_count.empty?, "Group of enterprises can not return empty"

  end

  #
  # Ranking companies according to the most payments a entreprises received.
  #
  # @return enterperises by featured payments.
  def most_paymented_ranking()

    # [Boolean] receives false value to sanction years.
    @all = false

    Preconditions.check_not_nil( :sanction_years )
    
    if params[:sanction_years]
      @all = true
      @enterprises_featured_payments = Enterprise.featured_payments.paginate(
                                                    :page => params[:page], :per_page => 20 )
    else
      @enterprises_featured_payments = Enterprise.featured_payments( 20 )
    end

    return @enterprises_featured_payments

    assert @enterprises_featured_payments.empty?, "Enterprises groups can not return empty"

  end

  #
  # Define largest sanctioned groups.
  #
  # @return enterprises by sanctions.
  def enterprise_group_ranking()

    @quantity_of_sanctions = params[:sanctions_count]
    @enterprises_group = Enterprise.where( sanctions_count: @quantity_of_sanctions )
    @enterprises_group_paginate = @enterprises_group.paginate(
                                :page => params[:page], :per_page => 10)


    return @enterprises_group_paginate

    assert @enterprises_group_paginate.empty?, "Enterprises groups can not return empty"

  end

  #
  # Define largest payments groups.
  #
  # @return enterprises by payments.
  def payment_group_ranking()

    @quantity_of_payments = params[:payments_count]
    assert @quantity_of_payments < 0, "Number of payments less than 0"
    
    @enterprises_payment = Enterprise.where( payments_count: @quantity_of_payments)
    @enterprises_payment_paginate = @enterprises_payment.paginate(
                                        :page => params[:page], :per_page => 10)

    return @enterprises_payment_paginate

  end


  #
  # Plotting by state sanctions chart.
  #
  # @return state chart.
  def sanction_by_state_graph()

    # [String] keeps list of states.
    gon.states = @@states_list

    # [String] keeps total data by state.
    gon.data = total_by_state

    # [String] keeps graph title.
    title = "Chart Sanctions for State"

    # receives information for plot graph.
    @chart = sanction_by_state_graph_information()

    return @chart

  end

  #
  # Plotting by state sanctions informations chart.
  #
  # @return informations chart.
  def sanction_by_state_graph_information()

    title = "Chart Sanctions for State"

    @chart = LazyHighCharts::HighChart.new( "graph" ) do |parameters|

      logger.info("setting information for sanction by state graph.")

      Preconditions.check_not_nil( parameters )

      parameters.title( :text => title )
      if( params[:year_].to_i() != 0 )
        parameters.title(:text => params[:year_].to_i() )
      else
        logger.debug("params #{:year}")
      end

      logger.info("setting chart information.")

      # Defines values to draw sanction by state chart.
      parameters.xAxis( :categories => @@states_list )
      parameters.series( :name => "Number of Sanctions",
                                  :yAxis => 0, :data => total_by_state )
      parameters.yAxis [{:title => {:text => "Sanctions", :margin => 30} }, ]
      parameters.legend( :align => "right", :verticalAlign => "top", :y => 75,
                :x => -50, :layout => "vertical", )
      parameters.chart( {:defaultSeriesType => "column"} )

      return parameters
    end

  end

  #
  # Plotting type of sanctions chart.
  #
  # @return type of sanctions chart.
  def sanction_by_type_graph()

    title = "Chart Sanctions for Type"

    @chart = sanction_by_type_graph_information()

    # If is not state clone a state list to use.
    if ( !@states )
      logger.debug("cloning a list #{@@states_list.clone}.")
      @states = @@states_list.clone
      @states.unshift( "All" )
    else
      logger.info("it is a #{@states}")
    end

    respond_to do |format|
      Preconditions.check_not_nil( format )
      format.html # show.html.erb
      format.js
    end

  end

  #
  # Plotting type of sanctions information chart.
  #
  # @return type of sanctions information chart.
  def sanction_by_type_graph_information()

    title = "Sanction graph by type"
    LazyHighCharts::HighChart.new( "pie" ) do |format|

      logger.info("build information for chart.")

      Preconditions.check_not_nil( format )

      # Defines values to draw sanction by type chart.
      format.chart({:defaultSeriesType => "pie" ,:margin => [50, 10, 10, 10]} )
      format.series( {:type => "pie", :name => "Found Sanctions",
                                                                :data => total_by_type} )
      format.options[:title][:text] = title
      format.legend( :layout => "vertical" )
      format.legend_style( :style => {:left => "auto", :bottom => 'auto',
                           :right => "50px",:top => "100px"})
      format.plot_options( :pie => {:allowPointSelect => true, :cursor => "pointer",

                      :dataLabels => {:enabled => true, :color => "black",
                      :style => {:font => "12px Trebuchet MS, Verdana, sans-serif"}
                    } 
                  })

    end
  end    

  #
  # List of total of sanctions in a especific state in a especific year.
  #
  # @return list of sacntions in a state on a year.
  def total_by_state()

    # [String] array of string that keep the results of sanctions by state.
    sanction_by_state_results = []

    # Receives years that has sanction.
    @years = @@sanction_years

    # Takes states that has sanction in state list to show by year.
    @@states_list.each() do |sanction_state|

      logger.info("finding sanction by state in @@states_list.")

      # [String] keeps state found by its abbreviation.
      state = State.find_by_abbreviation( "#{sanction_state}" )

      logger.info("find sanction by state id.")

      # [String] keeps sanctions in a state, by state id.
      sanctions_by_state = Sanction.where( state_id: state[:id] )

      # [Integer] array with year that has sanctions.
      selected_year = []

      logger.debug("declare array with years that has sanctions.")

      # Verify if year has sanction by state.
      if( params[:year_].to_i() != 0 )
        sanctions_by_state.each do |sanction_state|
          if( sanction_state.initial_date.year() ==  params[:year_].to_i() )
            selected_year << sanction_state
          else
            logger.debug("year without sanction #{:year}")
          end
      end
        sanction_by_state_results << ( selected_year.count() )
      else
        sanction_by_state_results << ( sanctions_by_state.count() )
      end
    end

    return sanction_by_state_results

  end

  #
  # List of total of sanctions by state in a especific state in a especific year.
  #
  # @return [String] list of total sanctions by its type.
  def total_by_type()

    # List with sanctions by state.
    total_sanction_state_result = []

    # List with santions by type.
    total_sanction_by_type_result = []

    iterator = 0

    logger.info("find state by abbreviation")

    # [String] receives state by its abbreviation.
    state = State.find_by_abbreviation( params[:state_] )

    # Takes sancton by type in list to show by state..
    @@sanction_type_list.each do |sanction_type_|

      Preconditions.check_not_nil( sanction_type_ )

      # [String] keeps sanction found by its description.
      sanction = SanctionType.find_by_description( sanction_type_[0] )

      # [String] keeps sanction by its type.
      sanctions_by_type = Sanction.where( sanction_type:  sanction )

      if( params[:state_] && params[:state_] != "All" )
        sanctions_by_type = sanctions_by_type.where( state_id: state[:id] )
      else
        logger.debug("no sanctions_by_type #{sanctions_by_type}")
      end

      # Concatenate sanction type in the result list, to have all sanctions by type.
      iterator = iterator + ( sanctions_by_type.count )
      total_sanction_by_type_result<< sanction_type_[1]
      total_sanction_by_type_result << ( sanctions_by_type.count )
      total_sanction_state_result << total_sanction_by_type_result
      total_sanction_by_type_result = []
    end


    total_sanction_by_type_result << "Uninformed"
      
      if ( params[:state_] && params[:state_] != "All" )
        Preconditions.check_not_nil( total )
        total = Sanction.where(state_id: state[:id] ).count
      else
        total = Sanction.count
      end

    # Sort sanction state list.
    total_sanction_by_type_result << ( total - iterator )
    total_sanction_state_result << total_sanction_by_type_result
    total_sanction_state_result = total_sanction_state_result.sort_by{ |i| i[0] }

    return total_sanction_state_result
  end

end