class Miamir.Models.Member extends Backbone.Model
  paramRoot: 'member'

  defaults:
    email: null

class Miamir.Collections.MembersCollection extends Backbone.Collection
  model: Miamir.Models.Member
  url: ()=>
    return '/teams/'+@team_id+'/members'

  initialize:(options)->
    @team_id = options.team_id