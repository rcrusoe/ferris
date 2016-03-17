var URL;
var PagesController = Paloma.controller('Pages');

PagesController.prototype.rec = function() {
  URL = this.params['URL'];

  // Change button styling on click.
  $(".cards").click(function(e){
    e.preventDefault();
    var id = $(this).attr('id');
    ga('send', 'event', 'button', 'click', 'recommendation', id);
    $(this).find('button').toggleClass("basic");
    $(location).attr('href', URL+'/another');
  });
};
