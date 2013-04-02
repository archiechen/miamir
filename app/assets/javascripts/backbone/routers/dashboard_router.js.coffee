class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @remain_data = options.remain_data
    @burning_data = options.burning_data
    @members = new Miamir.Collections.MembersCollection(team_id:options.team_id)
    @members.reset options.members
  routes:
    ".*"        : "index"

  index: =>
    @team_selector = new Miamir.Views.Teams.SelectorView()
    @members_view = new Miamir.Views.Teams.MembersView(members:@members)
    $("#members_board").prepend(@members_view.render().el)

    options = 
      colors: ["#750000", "#F90", "#777", "#555","#002646","#999","#bbb","#ccc","#eee"]
      series: 
        lines: 
          show: true 
          fill: true
          lineWidth: 4 
          steps: false
          fillColor:  
            colors: [
              {opacity: 0.4}
              {opacity: 0}
            ] 
        points: 
          show: true
          radius: 4
          fill: true
      legend: 
        position: 'ne'
      tooltip: true
      tooltipOpts: 
        content: '%s: %y'
      xaxis: 
        mode: "time"
        timeformat: "%m/%d"
        timezone:"browser"
      grid: 
        borderWidth: 2
        hoverable: true
    
    
    el = $("#burning-chart")

    data = [
      { data:@remain_data, label:"Remain" }
      { data:@burning_data, label:"Burning" }
    ]

    if el.length
      $.plot(el, data, options )
    