Miamir.Views.Tasks ||= {}

#必须继承后使用
class Miamir.Views.Tasks.TaskboardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskboard"]
  wip_tmpl:_.template('<span id="wip_limit" class="label label-important pull-right"><%=limit%></span>')
  
  className: "span3"

  initialize: () ->
    if not _.isUndefined(@options.className)
      @$el.removeClass('span3')
      @$el.addClass(@options.className)
    @options.tasks.bind('reset', @addAll)
    @options.tasks.bind('add', @addOne) 
    @options.tasks.comparator = (task)->
      return -(new Date(task.get('updated_at')).getTime())
    _.bindAll @, "addOne"
    _.bindAll @, "fetch"
    
  addAll: () =>
    @$("#list-cards").empty()
    @$("#total_scale").html(0)
    @options.tasks.each(@addOne)

  addOne: (task) ->
    task.unbind 'drag_completed',@remove
    task.bind 'drag_completed',@remove
    view = new Miamir.Views.Tasks.TaskCardView({model : task})
    @$("#list-cards").append(view.render().el).fadeIn()

  remove:(event)=>
    @options.tasks.remove event.old_task
    event.old_task.unbind 'drag_completed',@remove

  fetch:(team)->
    @options.tasks.fetch {data:{task:{status:@name,team_id:team.id}}}

  render: () ->
    $(@el).html(@template(name:@name))
    @addAll()
    @$(".well-taskboard").attr("id",@name)
    @$(".well-taskboard").droppable({
      accept: @options.accepts,
      activeClass: "well-taskboard-active",
      drop: @drop
    })
    return this

  drop: (event,ui)=>
    that = this
    cid = $(ui.helper).attr('data-cid')
    _.each @options.from_tasks,(from_collection)->
      from_collection.find (from_task)->
        if from_task.cid == cid
          from_task.bind "req_error",that.on_error
          that.dropped_handle.call that,from_task

  on_error:(xhr,task)=>
    bootbox.classes "alert-box"
    switch xhr.status
      when 400 then bootbox.alert "超过了WIP上限，请消除瓶颈先！"
      when 401 then bootbox.alert "这不是你的任务。"
      when 409 
        bootbox.classes "prompt-box"
        estimate_view = new Miamir.Views.Tasks.EstimateView({model:task})
        bootbox.confirm estimate_view.render().el, (result) ->
          estimate_view.save() if result
      when 412
        bootbox.classes "prompt-box"
        scale_view = new Miamir.Views.Tasks.ScaleView({model:task})
        bootbox.dialog scale_view.render().el,[{
          "label" : "$1",
          "class" : "btn-success",
          "callback": ->
              scale_view.scale(1)
        },{
          "label" : "$2",
          "class" : "btn-info",
          "callback": ->
              scale_view.scale(2)
        },{
          "label" : "$4",
          "class" : "btn-warning",
          "callback": ->
              scale_view.scale(4)
        },{
          "label" : "$8",
          "class" : "btn-danger",
          "callback": ->
              scale_view.scale(8)
        }],
        {onEscape:true}


    task.unbind "req_error",@on_error

class Miamir.Views.Tasks.BacklogTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () ->
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Backlog"

  dropped_handle:(from_task)=>
    that = this
    from_task.bind "drag_completed",@on_cancel
    from_task.cancel()

  on_cancel:(event)=>
    this.options.tasks.add(event.new_task,{silent: true})
    this.render()
    event.old_task.unbind "drag_completed",@on_cancel

  #override
  fetch:(team)->
    @options.tasks.fetch {data:{task:{status:"New",team_id:team.id}}}

  
class Miamir.Views.Tasks.ReadyTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () ->
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Ready"

  dropped_handle:(from_task)=>
    that = this
    from_task.bind "drag_completed",@on_checkout
    from_task.checkout()

  on_checkout:(event)=>
    this.options.tasks.add(event.new_task,{silent: true})
    this.render()
    event.old_task.unbind "drag_completed",@on_checkout

  #override
  fetch:(team)->
    @$("#wip_limit").html(team.working_in_ready_limit)
    Miamir.Views.Tasks.TaskboardView.prototype.fetch.call(this,team)

  #override
  render: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.render.call(this)
    @$(".taskboard-header").append(@wip_tmpl({limit:@options.team.get('working_in_ready_limit')}))
    return this


class Miamir.Views.Tasks.ProgressTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () ->
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Progress"

  #override add one
  addOne: (task) =>
    task.bind 'drag_completed',@remove
    view = new Miamir.Views.Tasks.ProgressTaskCardView({model : task})
    @$("#list-cards").append(view.render().el).fadeIn()

  dropped_handle:(from_task)=>
    from_task.bind "drag_completed",@on_checkin
    from_task.checkin()

  on_checkin:(event)=>
    @options.tasks.add(event.new_task,{silent: true})
    @render()
    event.old_task.unbind "drag_completed",@on_checkin

  #override
  fetch:(team)->
    @$("#wip_limit").html(team.working_in_progress_limit)
    Miamir.Views.Tasks.TaskboardView.prototype.fetch.call(this,team)

  #override
  render: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.render.call(this)
    @$(".taskboard-header").append(@wip_tmpl({limit:@options.team.get('working_in_progress_limit')}))
    return this


class Miamir.Views.Tasks.DoneTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () ->
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Done"

  dropped_handle:(from_task)=>
    that = this
    from_task.bind "drag_completed",(event)->
      that.options.tasks.add(event.new_task,{silent: true})
      that.render()
    from_task.done() 
