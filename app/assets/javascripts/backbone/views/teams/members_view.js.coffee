Miamir.Views.Teams ||= {}

class Miamir.Views.Teams.MembersView extends Backbone.View
  tagName: "div"

  className: "row-fluid"

  template: JST["backbone/templates/teams/members"]
  gravatar_templ: _.template('<img src="http://gravatar.com/avatar/<%=gravatar%>?s=80&amp;d=retro&amp;r=x" title="<%=email%>">')

  events:
    "click #add_member" : "add_member"

  initialize:->
    @options.members.bind "reset",@addAll
    @options.members.bind "add",@addOne

  addOne:(member)=>
    if !_.isUndefined(member.get("gravatar"))
      @$("#members").append @gravatar_templ(member.toJSON())

  addAll:=>
    @$("#members").empty()
    @options.members.each @addOne

  add_member: =>
    console.log "add member " + @$("#member_email").val() 
    
  render: =>  
    $(@el).html @template()
    @addAll() 

    return this   

