#encoding: utf-8
require 'spec_helper'
describe TasksController do
  include Devise::TestHelpers
  before do
    @user = FactoryGirl.create(:user)

    @new_task = FactoryGirl.create(:task,:scale=>2)
    @new_task_no_scale = FactoryGirl.create(:task)
    
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

    it "如果task的scale不为0，从New拖到Ready，checkout应该返回200" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      put :checkout, :id => @new_task.id

      assert_response 200
    end

    it "设置scale=1，从New拖到Ready，checkout应该返回200" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      put :checkout, :id => @new_task_no_scale.id,:scale=>1

      assert_response 200
    end

    it "如果task的scale=0，从New拖到Ready，checkout应该返回412" do
      controller.stub(:current_user).and_return(@user) # no need for a real user here
      
      put :checkout, :id => @new_task_no_scale.id

      assert_response 412
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