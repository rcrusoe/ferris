var EVENTS_URL;
var EventsController = Paloma.controller('Events');

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
      url         : EVENTS_URL + "/get_address_and_loc",
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
