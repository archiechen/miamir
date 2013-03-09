class Miamir.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    title: null
    status: null
    description: null

  putjson:(url,callback)->
    $.ajax url,
      type: 'PUT'
      dataType: 'json'
      success:callback

  checkin:(callback)->
    @putjson '/tasks/'+@id+"/checkin",callback

  checkout:(callback)->
    @putjson '/tasks/'+@id+"/checkout",callback

  done:(callback)->
    @putjson '/tasks/'+@id+"/done",callback

class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
