Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.TaskboardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskboard"]
  
  className: "span4"

  initialize: () =>
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
    $(@el).html(@template(name:@options.name))
    @addAll()
    @$(".well-taskboard").attr("id",@options.name)
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
          ui.draggable.fadeOut ()->
            from_task.checkin (task)->
              from_collection.remove from_task
              that.options.tasks.add task 
              that.render()
            
