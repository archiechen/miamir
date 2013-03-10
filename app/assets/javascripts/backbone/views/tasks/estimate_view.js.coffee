Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.EstimateView extends Backbone.View
  template : JST["backbone/templates/tasks/estimate"]

  save:()->
    @model.estimate(@$("#estimate").val())

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this
