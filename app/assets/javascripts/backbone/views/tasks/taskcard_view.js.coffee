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

class Miamir.Views.Tasks.ProgressTaskCardView extends Miamir.Views.Tasks.TaskCardView

  gravatar_templ: _.template('<div class="list-card-members"><img class="member" src="http://gravatar.com/avatar/<%=gravatar%>?s=40&amp;d=retro&amp;r=x" title="<%=email%>"></div>'),

  initialize:()->
    Miamir.Views.Tasks.TaskCardView.prototype.initialize.call(this)

  render: ->
    Miamir.Views.Tasks.TaskCardView.prototype.render.call(this);
    @$('#card').append(@gravatar_templ(@model.get('owner')))
    return this
  