#encoding: utf-8
require 'spec_helper'

describe Task do

  before do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)

    @user_hastask = FactoryGirl.create(:user_hastask)
    @progress_task = FactoryGirl.create(:progress_task,:owner_id=>2)
    @ready_task = FactoryGirl.create(:task,:estimate=>0)
  end

  describe "checkin" do
    it "If the current user does not have the processing task, checkin should return true" do
      @task.checkin(@user).should be_true
      @task.status.should == "Progress"
      @task.owner.should == @user
      @task.should have(1).durations
    end

    it "If the current user is being processed in the task, checkin should raise BadRequest" do
      expect{
        @task.checkin(@user_hastask)
      }.to raise_error(ActiveResource::BadRequest)
      @task.status.should == "Ready"
      @task.owner.should == nil
    end
    
    it "If the estimate of a task is 0, checkin should raise ResourceConflict" do
      expect{
        @ready_task.checkin(@user)
      }.to raise_error(ActiveResource::ResourceConflict)
      @task.status.should == "Ready"
      @task.owner.should == nil
    end

  end

  describe "checkout" do
    it "如果是自己的任务，checkout应该返回true" do
      @progress_task.checkout(@user_hastask).should be_true
      @progress_task.status.should == "Ready"
      @progress_task.owner.should == nil
    end

    it "如果不是自己的任务，checkout应该raise UnauthorizedAccess" do
      expect{
        @progress_task.checkout(@user)
      }.to raise_error(ActiveResource::UnauthorizedAccess)
      @progress_task.status.should == "Progress"
      @progress_task.owner.should == @user_hastask
    end
  end

end