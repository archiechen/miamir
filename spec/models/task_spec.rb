#encoding: utf-8
require 'spec_helper'

describe Task do

  before do
    @user = FactoryGirl.create(:user)
    @task = FactoryGirl.create(:task)

    @user_hastask = FactoryGirl.create(:user_hastask)
    @progress_task = FactoryGirl.create(:progress_task,:owner_id=>2)
  end

  describe "operation on dashboard" do
    it "如果当前用户没有处理中的任务，checkin应该返回true" do
      @task.checkin(@user).should be_true
      @task.status.should == "Progress"
      @task.owner.should == @user
    end

    it "如果当前用户有任务正在处理中，checkin应该返回false" do
      @task.checkin(@user_hastask).should be_false
      @task.status.should == "Ready"
      @task.owner.should == nil
    end

    it "如果是自己的任务，checkout应该返回true" do
      @progress_task.checkout(@user_hastask).should be_true
      @progress_task.status.should == "Ready"
      @progress_task.owner.should == nil
    end

    it "如果不是自己的任务，checkout应该返回false" do
      @progress_task.checkout(@user).should be_false
      @progress_task.status.should == "Progress"
      @progress_task.owner.should == @user_hastask
    end
  end

end