Miamir.Views.Tasks ||= {}

#必须继承后使用
class Miamir.Views.Tasks.TaskboardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskboard"]
  
  className: "span4"

  initialize: () =>
    @options.tasks.bind 'reset', @addAll
    @options.tasks.bind 'add', @addOne 
    @options.tasks.comparator = (task)->
      return task.get 'id'
    _.bindAll @, "drop"
    _.bindAll @, "remove"
    
  addAll: () =>
    @options.tasks.each(@addOne)

  addOne: (task) =>
    console.log 'call add one'
    task.bind 'put_success',@remove
    view = new Miamir.Views.Tasks.TaskCardView({model : task})
    @$(".well-taskboard").append(view.render().el).fadeIn()

  remove:(task)=>
    console.log "remove from "+@name
    @options.tasks.remove task
    task.unbind 'put_success',@remove

  render: () =>
    console.log 'render board '+@name
    $(@el).html(@template(name:@name))
    @addAll()
    @$(".well-taskboard").attr("id",@name)
    @$(".well-taskboard").droppable({
      accept: @options.accepts,
      activeClass: "well-taskboard-active",
      drop: @drop
    })
    return this

  drop: (event,ui)->
    that = this
    cid = $(ui.helper).attr('data-cid')
    _.each @options.from_tasks,(from_collection)->
      from_collection.find (from_task)->
        if from_task.cid == cid
          from_task.bind "put_error",that.on_error
          that.dropped_handle.call that,from_task

  on_error:(xhr)->
    bootbox.classes "alert-box"
    switch xhr.status
      when 400 then bootbox.alert "一手提不住两条鱼，一眼看不清两行书。"
      when 401 then bootbox.alert "这不是你的任务。"
    from_task.unbind "put_error",@on_error

  
class Miamir.Views.Tasks.ReadyTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Ready"
    _.bindAll @, "on_checkout"

  dropped_handle:(from_task)->
    that = this
    from_task.bind "put_success",@on_checkout
    from_task.checkout()

  on_checkout:(old,task)->
    console.log "on check out"
    this.options.tasks.add(task,{silent: true})
    this.render()
    old.unbind "put_success",@on_checkout

class Miamir.Views.Tasks.ProgressTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Progress"
    _.bindAll @, "on_checkin"
  #override add one
  addOne: (task) =>
    console.log 'call add progress one'
    task.bind 'put_success',@remove
    view = new Miamir.Views.Tasks.ProgressTaskCardView({model : task})
    @$(".well-taskboard").append(view.render().el).fadeIn()

  dropped_handle:(from_task)->
    console.log 'bind on checkin'
    from_task.bind "put_success",@on_checkin
    from_task.checkin()

  on_checkin:(old,task)->
    console.log "on check in"
    @options.tasks.add(task,{silent: true})
    @render()
    old.unbind "put_success",@on_checkin

class Miamir.Views.Tasks.DoneTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Done"

  dropped_handle:(from_task)->
    that = this
    from_task.bind "put_success",(old,task)->
      console.log "accepted on done"
      that.options.tasks.add(task,{silent: true})
      that.render()
    from_task.done() 