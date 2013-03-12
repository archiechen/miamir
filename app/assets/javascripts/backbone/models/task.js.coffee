class Miamir.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    title: null
    status: null
    description: null
    estimate: 0

  http_call:(method,url,event,data="")->
    that = this
    $.ajax url,
      type: method
      data: data
      dataType: 'json'
      success:(new_task)->
        that.trigger(event,{old_task:that,new_task:new_task})
      error:(xhr, options, message)->
        that.trigger('put_error',xhr,that)

  checkin:->
    @http_call 'PUT','/tasks/'+@id+"/checkin","drag_completed"

  checkout:->
    @http_call 'PUT','/tasks/'+@id+"/checkout","drag_completed"

  done:->
    @http_call 'PUT','/tasks/'+@id+"/done","drag_completed"

  estimate:(value)->
    @http_call 'PUT','/tasks/'+@id+"/checkin","drag_completed",{estimate:value}

  pair:->
    @http_call 'PUT','/tasks/'+@id+"/pair","paired_completed"

  leave:->
    @http_call 'DELETE','/tasks/'+@id+"/pair","paired_completed"

  cancel:->
    @http_call 'PUT','/tasks/'+@id+"/cancel","drag_completed"

class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
