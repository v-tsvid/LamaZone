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
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .
//= require bootstrap-slider

$.fn.stars = function() {
  return $(this).each(function() {
    // Get the value
    var val = parseFloat($(this).html());
    val = Math.round(val * 2) / 2;
    // Make sure that the value is in 0 - 5 range, multiply to get width
    var size = Math.max(0, (Math.min(5, val))) * 16;
    // Create stars holder
    var $span = $('<span />').width(size);
    // Replace the numerical value with stars
    $(this).html($span);
  });
}

$(document).on("ready page:load",function() {
  $('span.stars').stars();
});