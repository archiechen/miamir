class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @ready_tasks = new Miamir.Collections.TasksCollection()
    @ready_tasks.reset options.tasks

    @progress_tasks = new Miamir.Collections.TasksCollection()
    @done_tasks = new Miamir.Collections.TasksCollection()
    
  routes:
    ".*"        : "index"

  index: ->
    @ready_view = new Miamir.Views.Tasks.TaskboardView(name:'Ready',from_tasks:[@progress_tasks,@done_tasks], tasks: @ready_tasks, accepts:"#Progress .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@ready_view.render().el)

    @progress_view = new Miamir.Views.Tasks.TaskboardView(name:'Progress',from_tasks:[@ready_tasks,@done_tasks], tasks: @progress_tasks, accepts:"#Ready .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@progress_view.render().el)

    @done_view = new Miamir.Views.Tasks.TaskboardView(name:'Done',from_tasks:[@progress_tasks], tasks: @done_tasks, accepts:"#Progress .well-taskcard")
    $("#tasks_wall").append(@done_view.render().el)

