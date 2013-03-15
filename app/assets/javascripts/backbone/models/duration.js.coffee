class Miamir.Models.Duration extends Backbone.Model
  paramRoot: 'duration'

  defaults:
    name: null

class Miamir.Collections.DurationsCollection extends Backbone.Collection
  model: Miamir.Models.Duration
  url: ()=>
    return '/tasks/'+@task_id+'/durations'

  initialize:(options)->
    @task_id = options.task_id