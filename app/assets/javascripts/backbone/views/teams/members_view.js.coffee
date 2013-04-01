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
    @$("#members").append @gravatar_templ(member.toJSON())

  addAll:=>
    @$("#members").empty()
    @options.members.each @addOne

  add_member: =>
    @options.members.create {email: @$("#member_email").val()},{
      wait: true
      error:=>
        bootbox.alert "user not found."
    }
    
  render: =>  
    $(@el).html @template()
    @addAll() 

    return this   

