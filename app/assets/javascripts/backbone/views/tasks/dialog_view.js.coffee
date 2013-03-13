Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.EstimateView extends Backbone.View
  template : JST["backbone/templates/tasks/estimate"]

  save:()->
    @model.estimate(@$("#estimate").val())

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this

class Miamir.Views.Tasks.ScaleView extends Backbone.View
  template : JST["backbone/templates/tasks/scale"]

  scale:(value)->
    @model.scale(value)

  render : ->
    $(@el).html(@template(@model.toJSON()))
    return this