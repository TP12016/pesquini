=begin
File: welcome_controller_spec.rb
Purpose: Contains a unit test from class SessionController.
License: GPL v3.
Pesquini Group 6.
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

require "rails_helper"

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

end


RSpec.describe SessionsController, :type => :controller do

  user = User.new( login: "test_login", password: "test_password" )
  user.save

  subject { post :create, :session => {:login => "test_login_", :password => "test_password"} }

  describe   "GET" do

    describe '#create' do

      it "should log in user with correct login and password" do
        post :create, :session => {:login => "test_login", :password => "test_password"}
        expect( response ).to redirect_to( root_path )
      end

      it "shoul show a message of error when the login or password is invalid" do
        post :create, :session => {:login => "test_login", :password => "test_password_"}
        flash[:error].should eq( "Invalid login or password!" )
      end

    end

  end

  describe "#destroy" do

    it "should sign out the user" do
      post :create, :session => {:login => "test_login", :password => "test_password"}
      get :destroy
      expect( session[:user_id] ).to be( nil )
      expect( response ).to redirect_to( root_path )
    end

  end

end
