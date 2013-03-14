class Miamir.Models.Team extends Backbone.Model
  paramRoot: 'team'

  defaults:
    name: null

class Miamir.Collections.TeamsCollection extends Backbone.Collection
  model: Miamir.Models.Team
  url: '/teams'