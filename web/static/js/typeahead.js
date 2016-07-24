$(document).on('ready', function() {
  var $modal = $('.js-autocomplete-modal'),
      charSuggest,
      toonSuggest,
      divaSuggest,
      tagSuggest;

  $modal.on('shown.bs.modal', function(e) {
    var value = $('input.js-autocomplete-firedom').val(),
        input = $(this).find('input[name="search"]');

    input.val(value);
    if ( !('createTouch' in document) && !('ontouchstart' in document)) {
      input.focus();
    }
  });

  $modal.on('hidden.bs.modal', function() {
    var value = $(this).find('input[name="search"]').val(),
        input = $('input.js-autocomplete-firedom');

    input.val(value);
    if ( !('createTouch' in document) && !('ontouchstart' in document)) {
      setTimeout(function() { input.blur(); }, 1000);
    }

  });

  tagSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/suggest/tg/%QUERY.json'
  });
  divaSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/suggest/da/%QUERY.json'
  });
  toonSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/suggest/tn/%QUERY.json'
  });
  charSuggest = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/suggest/cr/%QUERY.json'
  });

  tagSuggest.initialize();
  divaSuggest.initialize();
  toonSuggest.initialize();
  charSuggest.initialize();

  return $('#remote .typeahead').typeahead({
    hint: true,
    highlight: true
  }, {
    name: 'tag-suggest',
    displayKey: 'value',
    source: tagSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Tag</i></h5>' }
  }, {
    name: 'diva-suggest',
    displayKey: 'value',
    source: divaSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Diva</i></h5>' }
  }, {
    name: 'toon-suggest',
    displayKey: 'value',
    source: toonSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Toon</i></h5>' }
  }, {
    name: 'char-suggest',
    displayKey: 'value',
    source: charSuggest.ttAdapter(),
    // templates: { header: '<h5 class="league-name"><i>Char</i></h5>' }
  });
  });
