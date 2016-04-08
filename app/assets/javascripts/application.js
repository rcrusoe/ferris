// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require semantic-ui
//= require typed.js
//= require countUp.js
//= require cocoon
//= require paloma
//= require recurring_select

$(document).ready(function(){
    $("#search-icon").click(function(){
        $("#search-icon").addClass("hidden");
        $("#remove-icon").removeClass("hidden");
        $('#search-form').transition('fade down');
        return false;
    });

    $("#remove-icon").click(function(){
        $("#search-icon").removeClass("hidden");
        $("#remove-icon").addClass("hidden");
        $("#search-form").transition("fade down");
        return false;
    });

    $('.ui.form')
        .form({
          fields: {
            title    : 'empty',
            short_blurb   : 'empty',
            description : 'empty',
            address : 'empty',
          }
        })
    ;
});