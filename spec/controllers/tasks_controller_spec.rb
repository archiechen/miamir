#encoding: utf-8
require 'spec_helper'
describe TasksController do
  include Devise::TestHelpers
  before do
    @user = FactoryGirl.create(:user)
    
    @progress_task = FactoryGirl.create(:progress_task,:estimate=>2) do |task|
      task.owner.task = task
    end

    @paired_task = FactoryGirl.create(:paired_task,:estimate=>2) do |task|
      task.owner.task = task
      task.partner.partnership = task
    end

    sign_in @user
  end


  describe "PUT checkout" do
    it "如果是不是自己的任务，checkout应该返回401" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      put :checkout, :id => @progress_task.id

      assert_response 401
    end
  end

  describe "PUT done" do
    it "如果是不是自己的任务，done应该返回401" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      put :done, :id => @progress_task.id

      assert_response 401
    end
  end

  describe "DELETE pair" do
    it "如果是不是自己的任务，done应该返回401" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      delete :leave, :id => @paired_task.id

      assert_response 401
    end
  end

end