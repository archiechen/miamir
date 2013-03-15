#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Miamir =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

cx_backbone_common =
  sync: (method, model, options) ->
    # Changed attributes will be available here if model.saveChanges was called instead of model.save
    if method == 'update' && model.changedAttributes()
      options.data = JSON.stringify(model.changedAttributes())
      options.contentType = 'application/json';
    Backbone.sync.call(this, method, model, options)
 
cx_backbone_model =
  # Calling this method instead of set will force sync to only send changed attributes
  # Changed event will not be triggered until after the model is synced
  saveChanges: (attrs) ->
    @save(attrs, {wait: true})
 
_.extend(Backbone.Model.prototype, cx_backbone_common, cx_backbone_model)
_.extend(Backbone.Collection.prototype, cx_backbone_common)