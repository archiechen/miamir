class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.where(params[:task])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  # PUT /tasks/1/checkin
  def checkin
    @task = Task.find(params[:id])
    @task.estimate = params[:estimate] if params[:estimate]
    begin
      @task.checkin(current_user)
      render json: @task
    rescue ActiveRecord::RecordInvalid => invalid
      if @task.errors.has_key?(:duplicate_task)
        render json:{},:status => 400
      elsif
        @task.errors.has_key?(:estimate)
        render json:{},:status => 409
      end
    end
  end

  # PUT /tasks/1/checkout
  def checkout
    @task = Task.find(params[:id])
    if !@task.owner.blank? and @task.owner != current_user
      render json:{},:status => 401
    else
      begin
        @task.scale = params[:scale] if params[:scale]
        @task.checkout(current_user)
        render json: @task
      rescue ActiveRecord::RecordInvalid => invalid
        if @task.errors.has_key?(:scale)
          render json:{},:status => 412
        end
      end
    end
  end

  # PUT /tasks/1/done
  def done
    @task = Task.where(:id=>params[:id],:owner_id=>current_user.id).first
    if @task.blank?
      render json:{},:status => 401
    else
      @task.done(current_user)
      render json: @task
    end
  end

  # PUT /tasks/1/cancel
  def cancel
    @task = Task.find(params[:id])
    @task.cancel()
    render json: @task
  end

  # PUT /tasks/1/pair
  def pair
    @task = Task.find(params[:id])
    begin
      @task.pair(current_user)
      render json: @task
    rescue ActiveRecord::RecordInvalid => invalid
      if @task.errors.has_key?(:duplicate_task)
        render json:{},:status => 400
      end
    end
  end

  # DELETE /tasks/1/pair
  def leave
    @task = Task.where(:id=>params[:id],:partner_id =>current_user.id).first
    if @task.blank?
      render json:{},:status => 401
    else
      @task.leave(current_user)
      render json: @task
    end
  end

end
