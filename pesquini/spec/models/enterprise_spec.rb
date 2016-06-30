=begin
File: enterprise_spec.rb
Purpose: Contains a unit test from class Enterprise.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

require 'spec_helper'
require 'rails_helper'

describe Enterprise do

  before do

    @enterprise = Enterprise.new
    @sanction = Sanction.new
    @payment = Payment.new
    @enterprise.cnpj = "555"
    @enterprise.corporate_name = "Samsung"
    @enterprise.save

    @sanction.initial_date = "01/02/2010".to_date
    @sanction.enterprise_id = @enterprise.id
    @sanction.save

    @payment.sign_date = "01/02/2011".to_date
    @payment.enterprise_id = @enterprise.id
    @payment.save

  end
  
  subject { @enterprise }
    it { should respond_to(:cnpj) }
    it { should respond_to(:corporate_name) }
  it { should be_valid }

  describe "uniqueness validation of cnpj" do
    
    describe "unique cnpj" do

      it "should be_valid" do
        uniqueness_enterprise = Enterprise.new
        uniqueness_enterprise.cnpj = "1234" 
        expect( uniqueness_enterprise ).to be_valid
      end

    end
    
  	describe "duplicated cnpj" do
    
    	it "should not be_valid" do
    	  duplicated_enterprise = Enterprise.new
    	  duplicated_enterprise.cnpj = "555"
    	  expect( duplicated_enterprise ).not_to be_valid
    	end
  
  	end

    describe "#payment_after_sanction" do
    
      it "should return false if have any sanction or any payment" do
        enterprise = Enterprise.new
        expect( enterprise.sanctions.count ).to be( 0 ) 
        expect( enterprise.payments.count ).to be( 0 )
        expect( enterprise.payment_after_sanction?() ).to be false
      end
    
      it "should return false if don't have payment after sanction" do
        expect( @enterprise.payment_after_sanction?() ).to be false
      end

      it "should return true if have  payment after sanction" do
        @sanction.initial_date = "01/02/2015".to_date
        @sanction.save
        expect( @enterprise.payment_after_sanction?() ).to be true
      end
    
    end

    describe "#self.enterprise_position" do
      
      it "should return 1 if there is only 1 enterprise" do
        enterprise = Enterprise.new
        enterprise.sanctions_count = 10000
        enterprise.save
        expect(Enterprise.enterprise_position( enterprise ) ).to eq( 1 );
      end
   
    end

    describe "#refresh!" do
      
      before do
      
        @enterprise = Enterprise.new
        @enterprise.cnpj = "12575431567543"
        @enterprise.save
      
      end

      it "should return enterprise" do
        expect( @enterprise.refresh! ).to eq( @enterprise );
      end

      it "should not return other enterprise" do
        expect( @enterprise.refresh! ).not_to eq( @enterprise );
      end  
   
    end
  
  end   

end
