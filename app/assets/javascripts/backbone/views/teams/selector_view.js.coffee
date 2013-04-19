Miamir.Views.Teams ||= {}

class Miamir.Views.Teams.SelectorView extends Backbone.View
  el:'#team_selector'

  events:
    "click .team-item" : "change_team"

  change_team:(event)=>
    that = this
    $.ajax "/teams/"+$(event.currentTarget).val()+"/current",
      type: "PUT"
      dataType: 'json'
      success:(current_team)->
        that.$('#current_team_name').html(event.target.text+'<b class="caret"></b>');
        that.$('.team-item').removeClass('active');
        that.$(event.currentTarget).addClass('active');
        if _.isUndefined(that.options.taskboards)
          window.location.reload(false)
        else
          _.each that.options.taskboards,(board)->
            board.fetch(current_team)
        

