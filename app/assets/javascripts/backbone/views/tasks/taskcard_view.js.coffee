Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.TaskCardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskcard"]

  tagName: "li"

  className: "well well-taskcard"

  render: ->
    $(@el).html(@template(@model.toJSON()))
    return this
