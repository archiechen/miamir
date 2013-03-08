class Miamir.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    title: null
    status: null
    description: null

  checkin:(callback)->
    $.ajax '/tasks/'+@id+"/checkin",
      type: 'PUT'
      dataType: 'json'
      success:callback


class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
