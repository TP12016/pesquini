=begin
File: application_helper_spec.rb
Purpose: Contains unit test from class ApplicationHelper.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

require "rails_helper"
  
include ApplicationHelper

RSpec.describe ApplicationHelper, :type => :helper do
  
  describe "#flash_class" do
  
    it "should return alert alert-info" do
      expect( flash_class( :notice ) ).to eq( "alert alert-info" )
    end

    it "should return alert alert-success" do
      expect( flash_class( :success ) ).to eq( "alert alert-success" )
    end
  
    it "should return alert alert-error" do
      expect( flash_class( :error ) ).to eq( "alert alert-error" )
    end
    
    it "should return alert alert-error" do
      expect( flash_class( :alert ) ).to eq( 'alert alert-error' )
    end
  
  end

end
