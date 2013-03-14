Miamir.Views.Teams ||= {}

class Miamir.Views.Teams.SelectorView extends Backbone.View
  el:'#team_selector'

  events:
    "click .team-item" : "change_team"

  initialize:()->
    _.bindAll(this, 'change_team');

  change_team:(event)->
    that = this
    $.ajax "/teams/"+$(event.currentTarget).val()+"/current",
      type: "PUT"
      dataType: 'json'
      success:(new_task)->
        that.$('#current_team_name').html(event.target.text+'<b class="caret"></b>');
        that.$('.team-item').removeClass('active');
        that.$(event.currentTarget).addClass('active');
        _.each that.options.taskboards,(board)->
          board.fetch($(event.currentTarget).val())
        

