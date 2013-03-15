Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.ShowView extends Backbone.View
  template: JST["backbone/templates/tasks/show"]
  edit_title_templ: JST["backbone/templates/tasks/edit-title"]
  edit_buttons_templ: JST["backbone/templates/tasks/edit-buttons"]
  duration_templ: JST["backbone/templates/tasks/duration"]

  initialize:->
    _.bindAll(this, 'addDuration');
    @model.once 'change',@render,this
    @durations = new Miamir.Collections.DurationsCollection(task_id:@model.get('id'))
    @durations.on "reset",@addAllDurations,this

  addDuration:(duration)->
    @$('#durations').append(@duration_templ(duration.toJSON())) if duration.get('minutes')

  addAllDurations:()->
    @durations.each(@addDuration)

  render: ->
    @durations.fetch()
    $.fn.editableform.template = @edit_title_templ()
    $.fn.editableform.buttons = @edit_buttons_templ()
    that = this
    $(@el).html(@template(@model.toJSON() ))
    @$('#task-title').editable
        mode: 'inline'
        inputclass: "edit-title"

    @$('#task-title').on 'save',(e, params)->
      that.model.set('title',params.newValue)
      that.model.saveChanges()

    @$('#task-title').on 'shown',()->
      $('.editable-inline').css('width',"100%")

    @$('#task-title').on 'click',(e)->
      e.stopPropagation();
      e.preventDefault();
      $('#task-title').editable('toggle');
    #edit description
    @$('#task-description').editable
        mode: 'inline'
        inputclass: "edit-description"

    @$('#task-description').on 'save',(e, params)->
      that.model.set('description',params.newValue)
      that.model.saveChanges()

    @$('#task-description').on 'shown',()->
      $('.editable-inline').css('width',"100%")
      

    @$('#task-description').on 'click',(e)->
      e.stopPropagation();
      e.preventDefault();
      $('#task-description').editable('toggle');

    
    return this
