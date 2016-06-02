=begin
File: sessions_helper_spec.rb
Purpose: Contains unit test from SessionHelper.
License: GPL v3.
Pesquini Group 6
FGA - UnB Faculdade de Engenharias do Gama - University of Brasilia.
=end

require "rails_helper"

include SessionsHelper

RSpec.describe SessionsHelper, :type => :helper do

  user = User.new( login: "test_login", password: "test_password" )
  user.save

  describe "#current_user?" do

    context "compared with @user" do

      it "must return true" do
        expect( current_user ).to eq( @user )
      end

    end

  end

  describe "#sign_out" do

    it "the user should logout with success" do
      sign_in( user )
      sign_out
      expect( current_user ).to be( nil )
    end

  end

  describe "#signed_in?" do

    it "expect signout to clear current_user" do
      sign_in( user )
      sign_out
      expect( signed_in? ).to be( false )
    end

  end

end
