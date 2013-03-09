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
      error:(xhr, options, error)->
        bootbox.classes "alert-box"
        switch xhr.status
          when 400 then bootbox.alert "一步一个脚印,同时只做一件事。"

  checkin:(callback)->
    @putjson '/tasks/'+@id+"/checkin",callback

  checkout:(callback)->
    @putjson '/tasks/'+@id+"/checkout",callback

  done:(callback)->
    @putjson '/tasks/'+@id+"/done",callback

class Miamir.Collections.TasksCollection extends Backbone.Collection
  model: Miamir.Models.Task
  url: '/tasks'
