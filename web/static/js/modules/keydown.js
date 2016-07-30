$(document).keydown(function(e) {
  if (! window.isMobile ) {
    var atag;

    switch(e.which) {
    case 37: // left
      atag = $(".js-keydown-prev-next a[rel='prev']");
      location.href = atag.attr('href');
      break;

    case 38: // up
      break;

    case 39: // right
      atag = $(".js-keydown-prev-next a[rel='next']");
      location.href = atag.attr('href');
      break;

    case 40: // down
      break;

    default:
      return; // exit this handler for other keys
    }

    e.preventDefault(); // prevent the default action (scroll / move caret)
  }
});