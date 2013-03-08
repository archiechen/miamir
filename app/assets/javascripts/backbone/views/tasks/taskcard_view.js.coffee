Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.TaskCardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskcard"]

  tagName: "div"

  className: "well-taskcard"

  initialize:()->
    _.bindAll(this, 'helper');

  helper: (event)->
    width = event.currentTarget.offsetWidth
    drag = $(@el).clone()
    drag.css('width',width+"px")
    drag.attr('data-cid',@model.cid)
    return drag

  render: ->
    that = this
    $(@el).html(@template(@model.toJSON()))
    $(@el).unbind()
    $(@el).draggable({
        addClasses: false,
        cancel: "a.ui-icon",
        revert: "invalid",
        containment: "document",
        helper:@helper,
        cursor: "move"
    })
    return this
