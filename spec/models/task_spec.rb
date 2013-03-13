#encoding: utf-8
require 'spec_helper'
require 'pp'
describe Task do

  before do
    @user = FactoryGirl.create(:user)

    @ready_task = FactoryGirl.create(:task,:status=>"Ready",:estimate=>10)
    @progress_task = FactoryGirl.create(:progress_task,:estimate=>2) do |task|
      task.owner.task = task
    end

    @paired_task = FactoryGirl.create(:paired_task,:estimate=>2) do |task|
      task.owner.task = task
      task.partner.partnership = task
    end

    @progress_task_other = FactoryGirl.create(:progress_task,:estimate=>2) do |task|
      task.owner.task = task
    end
    @ready_task_no_estimate = FactoryGirl.create(:task,:status=>'Ready',:estimate=>0)
  end

  describe "checkin" do
    it "If the current user does not have the processing task, checkin should return true" do
      @ready_task.checkin(@user).should be_true
      @ready_task.status.should == "Progress"
      @ready_task.owner.should == @user
      @ready_task.should have(1).durations
    end

    it "如果有处理中的任务，checkin抛出RecordInvalid，包含:duplicate_task错误" do
      expect{
        @ready_task.checkin(@progress_task.owner).should be_false
      }.to raise_error(ActiveRecord::RecordInvalid)
      @ready_task.errors.has_key?(:duplicate_task).should be_true
    end
    
    it "如果estimate=0，checkin抛出RecordInvalid，包含:estimate错误" do
      expect{
        @ready_task_no_estimate.checkin(@user)
      }.to raise_error(ActiveRecord::RecordInvalid)
      @ready_task_no_estimate.errors.has_key?(:estimate).should be_true
    end

    it "如果有处理中的任务，拖入一个estimate=0的任务，checkin抛出RecordInvalid，包含:duplicate_task错误" do
      expect{
        @ready_task_no_estimate.checkin(@progress_task.owner)
      }.to raise_error(ActiveRecord::RecordInvalid)
      @ready_task_no_estimate.errors.has_key?(:duplicate_task).should be_true
    end

  end

  describe "checkout" do
    it "如果是自己的任务，checkout应该返回true" do
      @progress_task.checkout(@progress_task.owner).should be_true
      @progress_task.status.should == "Ready"
      @progress_task.owner.should == nil
      @progress_task.partner.should == nil
    end
  end

  describe "done" do
    it "如果是自己的任务，done应该返回true" do
      @progress_task.done(@progress_task.owner).should be_true
      @progress_task.status.should == "Done"
      @progress_task.owner.should be_nil
      @progress_task.partner.should  be_nil
    end
  end

  describe "pair" do
    it "如果没有有处理中的任务，pair应该返回true" do
      @progress_task.pair(@user).should be_true
      @progress_task.partner.should ==@user
    end

    it "如果有处理中的任务，pair抛出RecordInvalid，包含:duplicate_task错误" do
      expect{
        @progress_task.pair(@progress_task_other.owner).should be_false
      }.to raise_error(ActiveRecord::RecordInvalid)
      @progress_task.errors.has_key?(:duplicate_task).should be_true
    end

    it "如果和自己结对，pair抛出RecordInvalid，包含:duplicate_task错误" do
      expect{
        @progress_task.pair(@progress_task.owner).should be_false
      }.to raise_error(ActiveRecord::RecordInvalid)
      @progress_task.errors.has_key?(:duplicate_task).should be_true
    end
  end

  describe "leave" do
    it "如果自己是partner，leave应该返回true" do
      @paired_task.leave(@paired_task.partner).should be_true
      @progress_task.partner.should be_nil
    end
  end

end