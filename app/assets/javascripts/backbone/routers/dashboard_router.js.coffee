class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @ready_tasks = new Miamir.Collections.TasksCollection()
    @ready_tasks.reset options.ready_tasks

    @progress_tasks = new Miamir.Collections.TasksCollection()
    @progress_tasks.reset options.progress_tasks
    
    @done_tasks = new Miamir.Collections.TasksCollection()
    @done_tasks.reset options.done_tasks

    @teams = new Miamir.Collections.TeamsCollection()
    @teams.reset options.current_user.teams

  routes:
    "index"     : "index"
    "planning"  : "planning"
    ".*"        : "index"

  index: ->
    $('#main-nav li').removeClass('active');
    $("#main-nav li:nth-child(1)").addClass('active');
    @ready_view = new Miamir.Views.Tasks.ReadyTaskboardView(from_tasks:[@progress_tasks,@done_tasks], tasks: @ready_tasks, accepts:"#Progress .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").html(@ready_view.render().el)

    @progress_view = new Miamir.Views.Tasks.ProgressTaskboardView(from_tasks:[@ready_tasks,@done_tasks], tasks: @progress_tasks, accepts:"#Ready .well-taskcard,#Done .well-taskcard")
    $("#tasks_wall").append(@progress_view.render().el)

    @done_view = new Miamir.Views.Tasks.DoneTaskboardView(from_tasks:[@progress_tasks], tasks: @done_tasks, accepts:"#Progress .well-taskcard")
    $("#tasks_wall").append(@done_view.render().el)

    @user_menu_view = new Miamir.Views.UserMenuView(teams:@teams)
    @user_menu_view.render();

  planning:->
    $('#main-nav li').removeClass('active');
    $("#main-nav li:nth-child(2)").addClass('active');
    @backlog_tasks = new Miamir.Collections.TasksCollection()
    that = this
    @backlog_tasks.fetch({
      data:{task:{status:'New'}},
      success:()->
        backlog_view = new Miamir.Views.Tasks.BacklogTaskboardView(className:"span6",from_tasks:[that.ready_tasks], tasks:that.backlog_tasks, accepts:"#Ready .well-taskcard")
        $("#tasks_wall").html(backlog_view.render().el)
        ready_view = new Miamir.Views.Tasks.ReadyTaskboardView(className:"span6",from_tasks:[that.backlog_tasks], tasks: that.ready_tasks, accepts:"#Backlog .well-taskcard")
        $("#tasks_wall").append(ready_view.render().el)
    })

