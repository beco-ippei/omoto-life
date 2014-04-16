// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var current_rotation = 0;
var rotateImage = function(deg) {
  var img_frame = $('.image-frame');
  var rotation = current_rotation + deg;
  if (Math.abs(rotation) == 360) {
    rotation = 0;
  }
  img_frame.css('-webkit-transform', 'rotate('+rotation+'deg)');
  current_rotation = rotation;
}
$('.rotate-r').on('click', function() {
  rotateImage(90);
});
$('.rotate-l').on('click', function() {
  rotateImage(-90);
});

