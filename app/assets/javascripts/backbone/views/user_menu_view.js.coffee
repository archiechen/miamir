Miamir.Views ||= {}

class Miamir.Views.UserMenuView extends Backbone.View
  el:'#user_menu'

  team_templ : _.template('<li class="team-item"><a href="#"><%=name%></a></li>')

  events:
    "click .team-item" : "active"

  initialize: () =>
    @options.teams.bind 'reset', @addAll
    @options.teams.bind 'add', @addOne 

  active:(event)->
    $('.team-item').removeClass('active')
    $(event.currentTarget).addClass('active')
    
  addAll: () =>
    @options.teams.each(@addOne)

  addOne: (team) =>
    @$(".nav-header").after(@team_templ(team.toJSON()))

  render : ->
    $('.team-item').remove()
    @addAll()
    $('.team-item:last').addClass('active')
    return this