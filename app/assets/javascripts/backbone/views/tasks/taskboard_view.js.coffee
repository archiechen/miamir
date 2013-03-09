Miamir.Views.Tasks ||= {}

#必须继承后使用
class Miamir.Views.Tasks.TaskboardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskboard"]
  
  className: "span4"

  initialize: () =>
    console.log 'call initialize'
    @options.tasks.bind 'reset', @addAll
    @options.tasks.bind 'add', @addOne 
    @options.tasks.comparator = (task)->
      return task.get 'id'
    _.bindAll @, "drop"
    
  addAll: () =>
    @options.tasks.each(@addOne)

  addOne: (task) =>
    view = new Miamir.Views.Tasks.TaskCardView({model : task})
    @$(".well-taskboard").append(view.render().el).fadeIn()

  render: =>
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
          that.dropped_handle.call that,from_task,(task)->
            ui.draggable.fadeOut ()->
              from_collection.remove from_task
            that.options.tasks.add task 
            that.render()
  
class Miamir.Views.Tasks.ReadyTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Ready"

  dropped_handle:(from_task,callback)->
    from_task.checkout callback

class Miamir.Views.Tasks.ProgressTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Progress"
  #override add one
  addOne: (task) =>
    view = new Miamir.Views.Tasks.ProgressTaskCardView({model : task})
    @$(".well-taskboard").append(view.render().el).fadeIn()

  dropped_handle:(from_task,callback)->
    from_task.checkin callback

class Miamir.Views.Tasks.DoneTaskboardView extends Miamir.Views.Tasks.TaskboardView
  initialize: () =>
    Miamir.Views.Tasks.TaskboardView.prototype.initialize.call(this)
    @name = "Done"

  dropped_handle:(from_task,callback)->
    from_task.done callback