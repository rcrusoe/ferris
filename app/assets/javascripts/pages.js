var URL;
var index;
var PagesController = Paloma.controller('Pages');

PagesController.prototype.rec = function() {
  URL = this.params['URL'];
  index = this.params['index'];

  // Change button styling on click.
  $(".recommend-button").click(function(e){
    e.preventDefault();
    var cb = generate_callback($(this));
    var id = $(this).attr('id');
    var eventName = $.trim($('.header'+'#'+id).text());
    mixpanel.track("Recommendation Clicked", {
      "request": index,
      "event": eventName
    }, setTimeout(cb, 500));
  });

  $("#customRec").click(function(e){
    e.preventDefault();
    var cb = generate_callback($(this));
    var recText = $('#custom_rec_text').val();
    mixpanel.track("Recommendation Clicked", {
      "request": index,
      "text": recText
    }, setTimeout(cb, 500));
  });

  function generate_callback(a) {
    return function() {
      a.find('button').toggleClass("basic");
      if (index < 9) {
        $(location).attr('href', URL+'/rec?index='+(index+1));
      }else {
        $(location).attr('href', URL+'/another');
      }
    }
  }
};
