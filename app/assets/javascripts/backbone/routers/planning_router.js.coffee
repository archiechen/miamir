class Miamir.Routers.PlanningRouter extends Backbone.Router
  initialize: (options) ->
    @ready_tasks = new Miamir.Collections.TasksCollection()
    @ready_tasks.reset options.ready_tasks
    
    @backlog_tasks = new Miamir.Collections.TasksCollection()
    @backlog_tasks.reset options.backlog_tasks

  routes:
    ".*"        : "index"

  index:->
    $('#main-nav li').removeClass('active');
    $("#main-nav li:nth-child(2)").addClass('active');
   
    @backlog_view = new Miamir.Views.Tasks.BacklogTaskboardView(className:"span6",from_tasks:[@ready_tasks], tasks:@backlog_tasks, accepts:"#Ready .well-taskcard")
    $("#tasks_wall").html(@backlog_view.render().el)
    @ready_view = new Miamir.Views.Tasks.ReadyTaskboardView(className:"span6",from_tasks:[@backlog_tasks], tasks: @ready_tasks, accepts:"#Backlog .well-taskcard")
    $("#tasks_wall").append(@ready_view.render().el)
    

    @team_selector = new Miamir.Views.Teams.SelectorView(taskboards:[@ready_view,@backlog_tasks])

