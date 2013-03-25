Miamir.Views.Tasks ||= {}

class Miamir.Views.Tasks.TaskCardView extends Backbone.View
  template: JST["backbone/templates/tasks/taskcard"]

  tagName: "li"

  className: "well-taskcard"

  events:
    "click .task-card .title" : "show"

  initialize:->
    @model.bind 'drag_completed',@drag_finished
    @model.on 'change',@render,this

  drag_finished:=>
    $(@el).fadeOut()
    @.model.unbind 'drag_completed',@drag_finished

  helper: (event)=>
    width = event.currentTarget.offsetWidth
    drag = $(@el).clone()
    drag.css('width',width+"px")
    drag.attr('data-cid',@model.cid)
    return drag

  show:=>
    show_view = new Miamir.Views.Tasks.ShowView({model:@model})
    show_view.show()

  render: ->
    $(@el).html(@template(@model.toJSON()))
    $(@el).draggable({
        addClasses: false,
        cancel: "a.ui-icon",
        revert: "invalid",
        containment: "document",
        helper:@helper,
        cursor: "move"
    })
    
    switch @model.get('scale')
      when 1 then @$('#scale').addClass("label-success")
      when 2 then @$('#scale').addClass("label-info")
      when 4 then @$('#scale').addClass("label-warning")
      when 8 then @$('#scale').addClass("label-danger")

    return this

class Miamir.Views.Tasks.ProgressTaskCardView extends Miamir.Views.Tasks.TaskCardView

  gravatar_templ: _.template('<img class="member" src="http://gravatar.com/avatar/<%=gravatar%>?s=40&amp;d=retro&amp;r=x" title="<%=email%>">'),
  memebers_templ: _.template('<div class="list-card-members"></div>')

  events:
    "click .list-card-members img:eq(0)" : "on_pair"
    "click .list-card-members img:eq(1)" : "on_leave"
    "click .task-card .title" : "show"

  initialize:()->
    Miamir.Views.Tasks.TaskCardView.prototype.initialize.call(this)
 
  on_pair:()=>
    that = this
    if _.isNull(@model.get('partner_id'))
      @model.bind "paired_completed",(event)->
        that.model.set(event.new_task)
        that.model.unbind "paired_completed"
      @model.bind "req_error",@on_error
      @model.pair()

  on_error:(xhr,task)=>
    bootbox.classes "alert-box"
    switch xhr.status
      when 400 then bootbox.alert "一手提不住两条鱼，一眼看不清两行代码。"

  on_leave:()=>
    that = this
    if not _.isNull(@model.get('partner_id'))
      @model.bind "paired_completed",(event)->
        that.model.set(event.new_task)
        that.model.unbind "paired_completed"
      @model.leave()

  render: =>
    Miamir.Views.Tasks.TaskCardView.prototype.render.call(this);
    @$('#card').append(@memebers_templ())
    @$('.list-card-members').append(@gravatar_templ(@model.get('owner')))
    if not _.isNull(@model.get('partner_id'))
      @$('.list-card-members').append(@gravatar_templ(@model.get('partner')))

    return this
  