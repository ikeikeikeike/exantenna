$(function() {
    var $modal = $('.js-autocomplete-modal');

    $modal.on('shown.bs.modal', function(e) {
      var value = $('input.js-autocomplete-firedom').val(),
          input = $(this).find('input[name="q"]');

      input.val(value);
      if ( !('createTouch' in document) && !('ontouchstart' in document)) {
        input.focus();
      }
    });

    $modal.on('hidden.bs.modal', function() {
      var value = $(this).find('input[name="q"]').val(),
          input = $('input.js-autocomplete-firedom');

      input.val(value);
      if ( !('createTouch' in document) && !('ontouchstart' in document)) {
        setTimeout(function() { input.blur(); }, 1000);
      }

    });
});
