Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.TaskCardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskcard"]

  tagName: "div"

  className: "well well-taskcard"

  initialize:()->
    _.bindAll(this, 'helper');

  helper: (event)->
    width = event.currentTarget.offsetWidth
    drag = $(@el).clone()
    drag.css('width',width+"px")
    return drag

  render: ->
    $(@el).html(@template(@model.toJSON()))
    $(@el).draggable({
        addClasses: false,
        cancel: "a.ui-icon",
        revert: true,
        containment: "document",
        helper:@helper,
        cursor: "move"
    })
    return this
