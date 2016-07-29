$(document).on('ready', function() {

  $('body').scrollspy({target: '#sidebarnav'})

  $('#sidebarnav nav').affix({
    offset: {
      top: 150,
      bottom: 1400,
    }
  });

});
