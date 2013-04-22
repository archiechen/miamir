class Miamir.Routers.KanbanRouter extends Backbone.Router
  initialize: (options) ->

    @backlog_tasks = new Miamir.Collections.TasksCollection()
    @backlog_tasks.reset options.backlog_tasks

    @ready_tasks = new Miamir.Collections.TasksCollection()
    @ready_tasks.reset options.ready_tasks

    @progress_tasks = new Miamir.Collections.TasksCollection()
    @progress_tasks.reset options.progress_tasks

    @done_tasks = new Miamir.Collections.TasksCollection()
    @done_tasks.reset options.done_tasks

    @team = new Miamir.Models.Team(options.team)

  routes:
    ".*"        : "index"

  index: ->
    @backlog_view = new Miamir.Views.Tasks.BacklogTaskboardView(from_tasks:[@ready_tasks], tasks:@backlog_tasks, accepts:"#Ready .well-taskcard")
    $("#tasks_wall").html(@backlog_view.render().el)

    @ready_view = new Miamir.Views.Tasks.ReadyTaskboardView(team:@team,from_tasks:[@backlog_tasks,@progress_tasks,@done_tasks], tasks: @ready_tasks, accepts:"#Backlog .well-taskcard,#Progress .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@ready_view.render().el)

    @progress_view = new Miamir.Views.Tasks.ProgressTaskboardView(team:@team,from_tasks:[@ready_tasks,@done_tasks], tasks: @progress_tasks, accepts:"#Ready .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@progress_view.render().el)

    @done_view = new Miamir.Views.Tasks.DoneTaskboardView(from_tasks:[@progress_tasks], tasks: @done_tasks, accepts:"#Progress .well-taskcard")
    $("#tasks_wall").append(@done_view.render().el)

    @team_selector = new Miamir.Views.Teams.SelectorView(taskboards:[@backlog_view,@ready_view,@progress_view,@done_view])
