var DASHBOARD_URL;
var DashboardController = Paloma.controller('Dashboard');

DashboardController.prototype.index = function() {

  // UI Setup
  $('.menu .item').tab();
  $('.menu .item').click(function(){
    drawLifetimeGraph();
    drawRetentionChart(metrics['retention']);
  });

  $('select.dropdown').dropdown();

  // Data Loading
  DASHBOARD_URL = this.params['URL'];
  var period = 0; // default is today
  var metrics; // hash from server
  loadDataFromServer();

  // TODO: switch to library
  function loadDataFromServer() {
    $.ajax({
      url         : DASHBOARD_URL + "/metrics",
      data        : JSON.stringify({ "period" : period }),
      dataType    : "text",
      type        : "POST",
      processData : false,
      cache       : false,
      contentType : "application/json",
      success     : function (response) {

        metrics = $.parseJSON(response);
        var options = {
          separator : ''
        };
        var count1 = new CountUp("conversations_over_period", $('#conversations_over_period').text(), metrics['conversations'], 0, 2, options);
        var count2 = new CountUp("users_over_period", $('#users_over_period').text(), metrics['new_users'], 0, 2, options);
        var count3 = new CountUp("repeat_users_over_period", $('#repeat_users_over_period').text(), metrics['repeat_users'], 0, 2, options);
        count1.start();
        count2.start();
        count3.start();
        drawLifetimeGraph();
        drawRetentionChart(metrics['retention']);
      }
    });
  };

  // PERIOD SELECTED FROM DROPDOWN
  $( "#period_select" ).change(function() {
    period = $(this).find("option:selected").index()
    loadDataFromServer();
  });

  // REPOPULATE GRAPH WITH DATA BASED ON TIME RANGE
  function drawLifetimeGraph() {
    $('#conversations').highcharts({
      chart: {
        type: ((period == 0 || period == 1) ? 'column' : 'area')
      },
      title: {
        text: 'Conversations'
      },
      xAxis: {
        categories: lineGraphCategories(),
        allowDecimals: false,
        labels: {
          formatter: function () {
            return this.value; // clean, unformatted number for year
          }
        }
      },
      yAxis: {
        title: {
          text: 'Conversations'
        },
        labels: {
          formatter: function () {
            return this.value;
          }
        }
      },
      tooltip: {
        pointFormat: '{point.y:,.0f} Conversations'
      },
      plotOptions: {
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      },
      series: [{
        name: 'Current Period',
        data: metrics['conversation_buckets']
      }]
    });
  };

  function lineGraphCategories() {
    switch (period) {
      case 0:
        return ['Today']
        break;
      case 1:
        return ['Yesterday']
        break;
      case 2:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        break;
      case 3:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        break;
      case 4:
        return metrics['dates']
        break;
      case 5:
        return metrics['dates']
        break;
      case 6:
        return metrics['dates']
        break;
      default:
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    }
  };

  // REPOPULATE GRAPH WITH DATA BASED ON TIME RANGE
  function drawRetentionChart(data) {

    $('#engagement').highcharts({

      chart: {
        type: 'heatmap',
        marginTop: 80,
        marginBottom: 80,
        plotBorderWidth: 0
      },


      title: {
        text: 'Retention By Week'
      },

      xAxis: {
        opposite: true
      },

      yAxis: {
        categories: data['weeks'],
        reversed: true,
        title: null
      },

      colorAxis: {
        min: 0,
        minColor: '#FFFFFF',
        maxColor: Highcharts.getOptions().colors[0]
      },

      legend: {
        enabled: false
      },

      tooltip: {
        formatter: function () {
          return '<b>' + this.point.value + '</b>%<br>';
        }
      },

      series: [{
        name: 'returning users per week',
        borderWidth: 1,
        data: data['data'],
        dataLabels: {
          enabled: true,
          color: '#000000'
        }
      }]

    });
  };
};