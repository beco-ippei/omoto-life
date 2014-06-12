// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var image_state = {
  rotation: 0,
  top: 0,
  right: 0,
  bottom: 0,
  left: 0
};

/**
 * 画像を回転する
 */
function rotateImage(deg) {
  var img_frame = $('.image-frame');
  var rotation = image_state.rotation + deg;
  if (Math.abs(rotation) == 360) {
    rotation = 0;
  }
  img_frame.css('-webkit-transform', 'rotate('+rotation+'deg)');
  image_state.rotation = rotation;
  checkImageState();
}

/**
 * 画像の編集状態を見て保存ボタンの表示制御を行う
 */
function checkImageState() {
  for (var idx in image_state) {
    if (image_state[idx] !== 0) {
      $('.image-manipulate.save').show();
      return;
    }
  }
  $('.image-manipulate.save').hide();
}

$('.rotate-r').on('click', function() {
  rotateImage(90);
});
$('.rotate-l').on('click', function() {
  rotateImage(-90);
});
