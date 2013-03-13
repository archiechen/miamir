#encoding: utf-8
require 'spec_helper'

describe Team do
  before do
    @team_with_members = FactoryGirl.create(:team_with_members)
  end

  describe "members" do
    it "team_with_members应该有2个成员" do
      @team_with_members.should have(2).members 
    end
  end
end
