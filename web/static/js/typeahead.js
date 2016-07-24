$(document).on('ready', function() {
  var $modal, charSuggest, toonSuggest, divaSuggest, tagSuggest;

  if (window.isMobile) {
    $modal = $('.js-autocomplete-modal');
    $modal.on('shown.bs.modal', function() {
      $(this).find('input[name="search"]').focus();
    });
    $modal.on('hidden.bs.modal', function() {
      $('input.js-autocomplete-firedom').val($(this).find('input[name="search"]').val());
    });
  }

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
