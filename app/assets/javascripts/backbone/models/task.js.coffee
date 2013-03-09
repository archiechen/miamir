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
      error:(xhr, options, message)->
        bootbox.classes "alert-box"
        switch xhr.status
          when 400 then bootbox.alert "一手提不住两条鱼，一眼看不清两行书。"
          when 401 then bootbox.alert "这不是你的任务。"

  checkin:(callback)->
    @putjson '/tasks/'+@id+"/checkin",callback

  checkout:(callback)->
    @putjson '/tasks/'+@id+"/checkout",callback

  done:(callback)->
    @putjson '/tasks/'+@id+"/done",callback

class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
