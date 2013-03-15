Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.ShowView extends Backbone.View
  template: JST["backbone/templates/tasks/show"]
  edit_title_templ: JST["backbone/templates/tasks/edit-title"]
  edit_buttons_templ: JST["backbone/templates/tasks/edit-buttons"]

  initialize:->
    @model.once 'change',@render,this

  render: ->
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

    @$('#task-description').on 'click',(e)->
      e.stopPropagation();
      e.preventDefault();
      $('#task-description').editable('toggle');
      
    return this
