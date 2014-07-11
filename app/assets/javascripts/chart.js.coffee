class @Chart
  constructor: (name, data) ->
    @name = name
    @data = data

  generateChart: (name, series, bands) ->
    $(@name).highcharts
      chart:
        defaultSeriesType: 'spline'
#        marginRight: 0
#        marginLeft: 0
#        marginBottom: 50
      title:
        text: 'Cloud Cover'
        x: -20
      subtitle:
        text: name,
        x: -20
      xAxis:
        type: 'datetime',
        dateTimeLabelFormats:
          hour: '%e/%H'
        plotBands: bands
      yAxis:
        title:
          text: 'Cloud Cover (%)'
        plotLines: [
          value: 0
          width: 1
          color: '#808080'
        ]
        min: -2
        max: 102
        startOnTick: false
        endOnTick: false
      plotOptions:
        series:
          lineWidth: 1
          marker:
            enabled: false
      tooltip:
        formatter: -> '<b>' + this.series.name + '</b><br/>' + Highcharts.dateFormat('%e. %b - %H:%M', this.x) + ': ' + this.y + '%'
      legend:
        layout: 'horizontal'
        align: 'centerr'
        verticalAlign: 'bottom'
        x: 0
        y: 0
        borderWidth: 0
      series: series

  processPoint: ->
#      if (data['availability']['link'])
#        link = $('<a/>');
#        link.attr('href', data['availability']['link'])
#        link.text(data['availability']['text'])
#        $('#availability').append(link)
#      else
#        $('#availability').text(data['availability']['text'])

    @.generateChart @data['name'], [
        name: 'Cloudiness'
        data: @data['forecast']['total']
      ,
        name: 'Low',
        data: @data['forecast']['low'],
        visible: false
      ,
        name: 'Medium',
        data: @data['forecast']['medium'],
        visible: false
      ,
        name: 'High',
        data: @data['forecast']['high'],
        visible: false
      ,
        name: 'Fog',
        data: @data['forecast']['fog'],
        visible: false
      ],
      @data['bands']

#$ ->
#  if $('#cloudchart').length
#    chart = new Chart('cloudchart')
#    chart.processPoint()
