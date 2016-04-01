var EVENTS_URL;
var EventsController = Paloma.controller('Events');

EventsController.prototype.index = function() {
  // ON PAGE LOAD
  EVENTS_URL = this.params['URL'];
  var date = this.params['when'];
  var location = this.params['where'];
  var categories = this.params['what'];

  // if filter params exist, apply
  $("#when-select").dropdown('set selected',date);
  $("#where-select").dropdown('set selected',location);
  $("#categories-select").dropdown('set selected',categories);

  // RELOAD PAGE WITH NAV BAR FILTERS
  $( "#search-button" ).click(function() {

    // build URL PARAMS and check for nil values
    var URL = EVENTS_URL + '?';
    date = $("#when-select").dropdown('get value');
    if (typeof date == "string") {
      URL += 'when=' + date + '&'
    }
    location = $("#where-select").dropdown('get text');
    if (typeof location == "string" && location != "Everywhere") {
      URL += 'where=' + location + '&'
    }
    categories = $("#categories-select").dropdown('get value');
    if (typeof categories == "string" && categories != "") {
      URL += 'what=' + categories
    }

    window.location = URL;
  });
};

EventsController.prototype.new = function() {
  EVENTS_URL = this.params['URL'];

  $( "#event_place_id" ).change(function() {
    var place_id = $(this).find("option:selected").val();
    var idx = $(this).find("option:selected").index();

    if (idx == 0) {
      $('#event_address').val('')
    }else {
      getAddressAndLoc(place_id);
    }
  });

  function getAddressAndLoc(place_id) {
    $.ajax({
      url         : EVENTS_URL + "/events/get_address_and_loc",
      data        : JSON.stringify({ "place_id" : place_id }),
      dataType    : "text",
      type        : "POST",
      processData : false,
      cache       : false,
      contentType : "application/json",
      success     : function (response) {

        data = $.parseJSON(response);
        $('#event_address').val(data['address']);
        $('#event_neighborhood').val(data['loc']);
      }
    });
  };
};
