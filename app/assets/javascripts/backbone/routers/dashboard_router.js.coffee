class Miamir.Routers.DashboardRouter extends Backbone.Router
  initialize: (options) ->
    @remain_data = options.remain_data
    @burning_data = options.burning_data
    @ready_data = options.ready_data
    @progress_data = options.progress_data
    @done_data = options.done_data
    @members = new Miamir.Collections.MembersCollection(team_id:options.team_id)
    @members.reset options.members
  routes:
    ".*"        : "index"

  index: =>
    @team_selector = new Miamir.Views.Teams.SelectorView()
    @members_view = new Miamir.Views.Teams.MembersView(members:@members)
    $("#members_board").prepend(@members_view.render().el)

    burnings_data = [
      { data:@remain_data, label:"Remain" }
      { data:@burning_data, label:"Burning" }
    ]

    accumulation_data = [
      { data:@done_data, label:"Done" }
      { data:@progress_data, label:"Progress" }
      { data:@ready_data, label:"Ready" }
    ]

    @draw($("#burning-chart"), null, burnings_data,0)
    @draw($("#accumulation-chart"), true, accumulation_data,_.min(_.map(@done_data,(d)-> d[1])))

  draw: (el,stack,data,min)=>

    options = 
      colors: ["#750000", "#F90", "#777", "#555","#002646","#999","#bbb","#ccc","#eee"]
      series: 
        stack: stack
        lines: 
          show: true 
          fill: true
          lineWidth: 4 
          steps: false
          fillColor:  
            colors: [
              {opacity: 0.4}
              {opacity: 0.4}
              {opacity: 0.4}
            ] 
        points: 
          show: true
          radius: 4
          fill: true
      legend: 
        position: 'nw'
      tooltip: true
      tooltipOpts: 
        content: '%s: %y'
      xaxis: 
        mode: "time"
        timeformat: "%m/%d"
        minTickSize: [1, "day"]
        timezone:"browser"
      yaxis:
        min: min
      grid: 
        borderWidth: 2
        hoverable: true
    
    if el.length
      $.plot(el, data, options )



    