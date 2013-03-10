class Miamir.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    title: null
    status: null
    description: null

  putjson:(url)->
    that = this
    $.ajax url,
      type: 'PUT'
      dataType: 'json'
      success:(new_task)->
        that.trigger('put_success',that,new_task)
      error:(xhr, options, message)->
        that.trigger('put_error',xhr)

  checkin:->
    @putjson '/tasks/'+@id+"/checkin"

  checkout:->
    @putjson '/tasks/'+@id+"/checkout"

  done:->
    @putjson '/tasks/'+@id+"/done"

class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
