class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @tasks = new Miamir.Collections.TasksCollection()
    @tasks.reset options.tasks

  routes:
    ".*"        : "index"

  index: ->
    @view1 = new Miamir.Views.Tasks.TaskboardView(tasks: @tasks)
    $("#tasks_wall").html(@view1.render().el)
    @view2 = new Miamir.Views.Tasks.TaskboardView(tasks: @tasks)
    $("#tasks_wall").append(@view2.render().el)

    @view3 = new Miamir.Views.Tasks.TaskboardView(tasks: @tasks)
    $("#tasks_wall").append(@view3.render().el)

