#encoding: utf-8
require 'spec_helper'
describe Task do

  before do
    @user = FactoryGirl.create(:user)

    @ready_task = FactoryGirl.create(:task,:status=>"Ready",:estimate=>10,:scale=>5)
    @new_task = FactoryGirl.create(:task,:status=>"New",:scale=>10)
    @new_task_no_scale = FactoryGirl.create(:task,:status=>"New",:scale=>0)
    @progress_task = FactoryGirl.create(:progress_task,:estimate=>2,:scale=>5) do |task|
      task.owner.task = task
    end

    @paired_task = FactoryGirl.create(:paired_task,:estimate=>2,:scale=>1) do |task|
      task.owner.task = task
      task.partner.partnership = task
    end

    @progress_task_other = FactoryGirl.create(:progress_task,:estimate=>2,:scale=>1) do |task|
      task.owner.task = task
    end
    @ready_task_no_estimate = FactoryGirl.create(:task,:status=>'Ready',:estimate=>0,:scale=>1)
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
      @progress_task.owner.should  be_nil
      @progress_task.partner.should be_nil
    end

    it "如果任务的Scale不为0，checkout应该返回true" do
      @new_task.checkout(@progress_task.owner).should be_true
      @new_task.status.should == "Ready"
      @new_task.owner.should  be_nil
      @new_task.partner.should be_nil
    end

    it "如果任务的Scale=0，checkout抛出RecordInvalid，包含:scale错误" do
      expect{
        @new_task_no_scale.checkout(@user)
      }.to raise_error(ActiveRecord::RecordInvalid)
      @new_task_no_scale.errors.has_key?(:scale).should be_true
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

  describe "emptying" do
    it "执行emptying之后，所有Progress状态的任务都变为Ready，并且记录工时" do
      Task.emptying()
      t = Task.find(@progress_task.id)
      t.status.should =='Ready'
      t.durations.length == 1
      t.durations.first.minutes.should == 60

    end
  end

end