=begin
File: statistics_controller.rb
Purpose: Contains results of all search method.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

class StatisticsController < ApplicationController

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

    assert enterprise_group_array.empty?, "Array must not be empty!"

    # [String] keeps ranking of enterprises with most sanctions.
    enterprise_group_array = Enterprise.most_sanctioned_ranking()

    # [String] keeps array of enterprises.
    @enterprise_group = enterprise_group_array[0]

    # [String] keeps counting of enterprises group.
    @enterprise_group_count = enterprise_group_array[1]

    return @enterprise_group_count

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
      @enterprises = Enterprise.featured_payments.paginate( :page => params[:page], :per_page => 20 )
    else
      @enterprises = Enterprise.featured_payments( 10 )
    end

    return @enterprises

  end

  #
  # Define largest sanctioned groups.
  #
  # @return enterprises by sanctions.
  def enterprise_group_ranking()

    @quantidade = params[:sanctions_count]
    @enterprises = Enterprise.where( sanctions_count: @quantidade )
                                     .paginate( :page => params[:page], :per_page => 10 )

    return @enterprises

  end

  #
  # Define largest payments groups.
  #
  # @return enterprises by payments.
  def payment_group_ranking()

    @quantidade = params[:payments_count]
    @enterprises = Enterprise.where( payments_count: @quantidade )
                                     .paginate( :page => params[:page], :per_page => 10)

    return @enterprises

  end

  #
  # Plotting by state sanctions chart.
  #
  # @return state chart.
  def sanction_by_state_graph()

    # [String] keeps list of states.
    gon.states = @@states_list

    # [String] keeps total data by state.
    gon.dados = total_by_state

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

    LazyHighCharts::HighChart.new( "graph" ) do |parameters|
      Preconditions.check_not_nil( parameters )
      parameters.title( :text => title )
      if( params[:year_].to_i() != 0 )
        parameters.title(:text => params[:year_].to_i() )
      else
        # Nothing to do.
      end
      parameters.xAxis( :categories => @@states_list )
      parameters.series( :name => "Número de Sanções", :yAxis => 0, :data => total_by_state )
      parameters.yAxis [{:title => {:text => "Sanções", :margin => 30} }, ]
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

    title = "Gráfico Sanções por Tipo"

    @chart = sanction_by_type_graph_information()

    if ( !@states )
      @states = @@states_list.clone
      @states.unshift( "Todos" )
    else
      # Nothing to do.
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

    LazyHighCharts::HighChart.new( "pie" ) do |f|
      Preconditions.check_not_nil( f )
      f.chart({:defaultSeriesType => "pie" ,:margin => [50, 10, 10, 10]} )
      f.series( {:type => "pie", :name => "Sanções Encontradas", :data => total_by_type} )
      f.options[:title][:text] = title
      f.legend( :layout => "vertical", :style => {:left => "auto", :bottom => 'auto',
                :right => "50px", :top => "100px"} )
      f.plot_options( :pie => {:allowPointSelect => true, :cursor => "pointer",
                      :dataLabels => {:enabled => true, :color => "black",
                      :style => {:font => "12px Trebuchet MS, Verdana, sans-serif"}}
      } )
    end

  end

  #
  # List of total of sanctions in a especific state in a especific year.
  #
  # @return list of sacntions in a state on a year.
  def total_by_state()

    assert state_results.empty?, "The list must not be empty!"

    # [String] array of string that keep the results of sanctions by state.
    sanction_by_state_results = []

    @@states_list.each() do |sanction_state|

      Preconditions.check_not_nil( sanction_state )
      Preconditions.check_not_nil( state )
      Preconditions.check_not_nil( sanctions_by_state )

      # [String] keeps state found by its abbreviation.
      state = State.find_by_abbreviation( "#{sanction_state}" )

      # [String] keeps sanctions in a state, by state id.
      sanctions_by_state = Sanction.where( state_id: state[:id] )

      assert selected_year.empty, "List can't be empty."

      # [Integer] array with year that has sanctions.
      selected_year = []

      if( params[:year_].to_i() != 0 )
        sanctions_by_state.each do |sanction_state|
          if( sanction_state.initial_date.year() ==  params[:year_].to_i() )
            selected_year << sanction_state
          else
            # Nothing to do.
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
  # @return list of total sanctions by its type.
  def total_by_type()

    assert results.empty?, "The list must not be empty!"
    assert results2.empty?, "The list must not be empty!"


    results = []
    results2 = []
    cont = 0

    # [String] receives state by its abbreviation.
    state = State.find_by_abbreviation( params[:state_] )

    @@sanction_type_list.each do |sanction_type_|

      Preconditions.check_not_nil( sanction_type_ )

      # [String] keeps sanction found by its description.
      sanction = SanctionType.find_by_description( sanction_type_[0] )

      # [String] keeps sanction by its type.
      sanctions_by_type = Sanction.where( sanction_type:  sanction )

      if( params[:state_] && params[:state_] != "Todos" )
        sanctions_by_type = sanctions_by_type.where( state_id: state[:id] )
      else
        # Nothing to do.
      end

      cont = cont + ( sanctions_by_type.count )
      results2 << sanction_type_[1]
      results2 << ( sanctions_by_type.count )
      results << results2
      results2 = []
    end

    results2 << "Não Informado"
      Preconditions.check_not_nil( total )
      if ( params[:state_] && params[:state_] != "Todos" )
        total = Sanction.where(state_id: state[:id] ).count
      else
        total = Sanction.count
      end

    results2 << ( total - cont )
    results << results2
    results = results.sort_by{ |i| i[0] }

    return results
  end

end