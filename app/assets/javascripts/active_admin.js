//= require active_admin/base
//= require select2
//= require jquery-ui.min



$(document).ready(function() {

  $('.index_forms').find('input:text').each(function(index) {

    $(this).on('input', function(e) {
      $(this).parents('form').submit();
      $(this).effect("highlight", {color: 'green'}, 250);
    });

  });


  $('.index_forms').find('select').each(function(index) {

    $(this).on('change', function(e) {
      $(this).parents('form').submit();
    });

  });

  $('.index_forms').find('input:checkbox').each(function(index) {

    $(this).on('change', function(e) {
      $(this).parents('form').submit();
    });

  });

  $('.product_source_link').each(function(index){
    $(this).click( function() {
      $(this).parents('form').submit();
    });
  });




  //---------------------------------------//
  $(".select2able").select2({
    minimumInputLength: 2,
    allowClear: true,
	});

  $ajax_select2 = $(".ajax_select2able");
  
  $ajax_select2.width('400px');
  $ajax_select2.each( function(i, elm) {
    // To Add Label Tag for Select2
    $(elm).before('<label>' + $(elm).data('label') + '</label>');

    if ( $(elm).data('padding') == undefined )
      $(elm).parent('li').css('padding', '10');
    else
      $(elm).parent('li').css('padding-top', '10');

    $(elm).select2({
      minimumInputLength: 2,
      multiple: $(elm).data('multiple'),
      allowClear: true,
      ajax: {
        url: $(this).data('source'),
        quietMillis: 100,
        dataType: 'json',
        data: function(term, page) {
          return {
            q: term,
            page_limit: 10,
            page: page
          };
        },
        results: function(data, page) {
          var more = (page * 10) < data.total;
          return {results: data.records, more: more};
        }
      },
      initSelection : function (element, callback) { 
        var result = [];
        $(element.val().split(",")).each(function (k, v) {
          $.ajax({
            type: "get",
            url: element.data('source').replace('search', 'search_by'),
            async: false,
            dataType: 'json',
            data: { id: v},
            success: function(data){
              if (element.data('multiple')) { 
                result.push({id: data.record.id, text: data.record.text});
              } else {
                result = { id: data.record.id, text: data.record.text};
              }
            }
          });
        });
        callback(result); 
      }
    });

	});

	$(document).on('has_many_add:after', function(e, fieldset) {
    fieldset.find(".select2able").select2();
    $select2 = fieldset.find(".ajax_select2able");
    $select2.width('400px');

    $select2.each(function(){
      $elm = $(this);
      $elm.before('<label>' + $elm.data('label') + '</label>');

      if ( $elm.data('padding') == undefined )
        $elm.parent('li').css('padding', '10');
      else
        $elm.parent('li').css('padding-top', '10');  

      $elm.select2({
        minimumInputLength: 2,
        multiple: $elm.data('multiple'),
        ajax: {
          url: $elm.data('source'),
          quietMillis: 100,
          dataType: 'json',
          data: function(term, page) {
            return {
              q: term,
              page_limit: 10,
              page: page
            };
          },
          results: function(data, page) {
            var more = (page * 10) < data.total;
            return {results: data.records, more: more};
          }
        }
      });
    });
	});
  
});

