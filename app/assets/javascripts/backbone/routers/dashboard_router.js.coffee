class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @ready_tasks = new Miamir.Collections.TasksCollection()
    @ready_tasks.reset options.ready_tasks

    @progress_tasks = new Miamir.Collections.TasksCollection()
    @progress_tasks.reset options.progress_tasks
    
    @done_tasks = new Miamir.Collections.TasksCollection()
    @done_tasks.reset options.done_tasks

  routes:
    ".*"        : "index"

  index: ->
    @ready_view = new Miamir.Views.Tasks.ReadyTaskboardView(from_tasks:[@progress_tasks,@done_tasks], tasks: @ready_tasks, accepts:"#Progress .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").html(@ready_view.render().el)

    @progress_view = new Miamir.Views.Tasks.ProgressTaskboardView(from_tasks:[@ready_tasks,@done_tasks], tasks: @progress_tasks, accepts:"#Ready .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@progress_view.render().el)

    @done_view = new Miamir.Views.Tasks.DoneTaskboardView(from_tasks:[@progress_tasks], tasks: @done_tasks, accepts:"#Progress .well-taskcard")
    $("#tasks_wall").append(@done_view.render().el)

    @team_selector = new Miamir.Views.Teams.SelectorView(taskboards:[@ready_view,@progress_view,@done_view])
