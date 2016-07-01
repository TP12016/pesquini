=begin
File: enterprise_controller_spec.rb.
Purpose: Contains a unit test from class EnterpriseController.
License: GPL v3.
Pesquini Group 6.
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

require "rails_helper"

RSpec.describe EnterprisesController, :type => :controller do 
  
  before do
  
    @enterprise = Enterprise.create( cnpj: "12345" )
    @payment= Payment.create
    @enterprise.payments << @payment
    @sanction = Sanction.create
    @enterprise.sanctions << @sanction
  
  end

  describe "GET" do 
    
    describe "#index" do
  
      it "should work" do 
        get :index
        expect(response).to have_http_status(:success)
      end
  
    end
    
    describe "#show" do
    
      describe "with a registered enterprise" do 
    
        it "should work" do
          get :show, :id => @enterprise.id
          expect( response ).to have_http_status( :success )
        end
    
      end


      it "should show the correct enterprise" do
          get :show, :id => @enterprise.id
          expect( assigns( :enterprise ) ).to eq( @enterprise )
      end


      it "should show the enterprise's payments" do
          get :show, :id => @enterprise.id
          expect( assigns( :payments ) ).to include( @payment )
      end


      it "should show the enterprise's sanctions" do
          get :show, :id => @enterprise   .id
          expect( assigns ( :sanctions ) ).to include( @sanction )
      end

    
    end

    describe "#show_page_number" do 

      describe "with a registered enterprise" do

        it "should work" do
          get :show_page_number, :page => @page_number
          expect( response ).to have_http_status( :success )
        end

      end
    end 
  
  end

end
