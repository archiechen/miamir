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
      success:=>
        @$("#member_email").val('')
      error:=>
        bootbox.alert "user not found."
    }
    @$("#add_member").attr('disabled',"disabled")
    @$("#add_member").addClass('disabled')

    
  render: =>  
    $(@el).html @template()
    @addAll() 
    @$("#member_email").typeahead({
      source: (query, process) =>
        return $.getJSON(
            '/autocomplete/users'
            { term: query }
            (data)->
              return process(data)
            )
      updater:(item)=>
        @$("#add_member").removeAttr('disabled')
        @$("#add_member").removeClass('disabled')
        return item

    })
    return this   

