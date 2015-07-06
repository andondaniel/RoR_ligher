// this javascript is relevant to the MOVIE SHOW page & EPISODE page
var options, featureList, active_attributes;
$(document).ready(function() {

  // these are the filterable types. they correlate to classes under outfit and products
  // these are also the filterable values of each product; eg you can filter by brand or character, etc

  options = {
    valueNames: [ 'character', 'type', 'product-name', 'product-brand', 'product-price', 'price', 'product-character', 'product-category', 'filter_attributes' ]
  };

  // this determines the list of items that will be filterable (#outfits-list)
  featureList = new List('outfits-list', options);


  // This initializes an empty array called active-attributes
  active_attributes = [];

  // when you click an episode:
  // $('.')


  // when you click any filter button
  $('.filter-button').click(function() {

    // it takes the html inside the clicked button and stores it into a variable
    var clicked_button = $(this).html();

    // another array (randomly named 'yes') is initialized
    var yes = [];

    // this next block runs for the length of the array of active_attributes
    for (var i=0; i < active_attributes.length; i++) {
      // if the value of the specific filter is already included in the active_attributes list, then add a "yo" to the yes array
      if (clicked_button.indexOf(active_attributes[i]) > -1) {
        yes.push("yo");
      }
    }

    // if there are not elements in the yes array (aka the specific filter has not yet been added) or the number of active attributes is 0 (there is nothing currently being filtered) 
    if (yes.length === 0 || active_attributes.length === 0 ) {
      // add the filter to the list of filters
      $('#filter-list').append("<span class = 'filter-tag'></span>");
      $('.filter-tag:last').html(clicked_button);
      $('.filter-tag:last').append("<div class = 'filter-close'><i class='fa fa-times'></i></div>");

      // if you press the close button, it gets rid of the filter
      $('.filter-close').click(function() {
        var clicked_button = $(this).parent().text();

        for (var i = active_attributes.length - 1; i >= 0; i--) {
          if (active_attributes[i] == clicked_button) active_attributes.splice(i, 1);
        }

        if (active_attributes.length > 0)
          featureList.filter(function(item) {
            for (var i = 0; i < active_attributes.length; i++) {
              var attributes = item.values().filter_attributes;
              if ((attributes.indexOf(active_attributes[i]) == -1) || item.values().type != 'product') {
                return false; 
              }
            }
            return true;
          });
        else
          featureList.filter(function(item) {
            if (item.values().type != 'product')
              return false;
            else
              return true;
          });

        $(this).parent().remove();
      });
    }

    active_attributes.push(clicked_button);

    // If the product has an active attribute (filtered attribute), then don't show it.
    featureList.filter(function(item) {
      for (var i = 0; i < active_attributes.length; i++) {
        var attributes = item.values().filter_attributes;
        if (attributes.indexOf(active_attributes[i]) == -1) {
          return false;
        }
      }
      return true;
    });

  });



  // this if statement makes sure that the following doesn't trigger unless you are on a MOVIE SHOW or an EPISODE SHOW page
  if ($('.filter-content').length) {
  // this hides all PRODUCTS when user first lands on the page
    featureList.filter(function(item) {
      if (item.values().type == "product") {
        return false;
      } else {
        return true;
      }
    });
  };

  // when you click on a character, eg "Mark Zuckerberg"
  $('.filter').click(function() {

    // it identifies the character and stores it into a variable
    var character = $(this).find('.character-thumbbox-name').text();

    // it switches the selected filter to the new filter (highlights the selected filter)
    $('.character-thumbbox').removeClass('selected');
    $(this).children('.character-thumbbox').addClass('selected');


    featureList.filter(function(item) {
      // if the item belongs to the selected character, then show the item
      if ((item.values().character == character) && (item.values().type == "outfit")) {
        return true;
      } else {
        return false;
      }
    });

    // if SHOW PRODUCTS IS SELECTED
    if ($('#show-outfits').hasClass("nonactive")) {
      $('#open-filter').show();
      $('#sort-by-price').show();
      featureList.filter(function(item) {
        // if the item belongs to the selected character, then show the item
        if ((item.values().character == character) && (item.values().type == "product")) {
          return true;
        } else {
          return false;
        }
      });
    } else {
      return false;
    }

    return false;

  });


  // if you click the SHOW OUTFITS button:
  $('#show-outfits').click(function() {


    $('#showing-outfits').show();
    $('#showing-products').hide();
    $('#open-filter').hide();
    $('#sort-by-price').hide();

    // makes sure that "SHOW OUTFITS", not "SHOW PRODUCTS" is highlighted
    $('.show-outfits-or-products').addClass('nonactive');
    $(this).removeClass("nonactive");

    // if there is a CHARACTER selected,
    if ($('.selected').length) {

      // find that character's name
      var character = $('.selected').find('.character-thumbbox-name').text();

      featureList.filter(function(item) {
        // show only outfits and items that belong to that character
        if ((item.values().type == "outfit") && (item.values().character == character)) {
          return true;
        } else {
          return false;
        }
      });
    } else {
      // if a character hasn't been selected
        featureList.filter(function(item) {
        // show only outfits, without filtering out by character
        if (item.values().type == "outfit") {
          return true;
        } else {
          return false;
        }
      });
    }
  });

  // if you click the SHOW PRODUCTS button:
  $('#show-products').click(function() {

    $('#showing-products').show();
    $('#showing-outfits').hide();
    $('#open-filter').show();
    $('.episode-filter-background').hide();
    $('#sort-by-price').show();
    $('#filter-episodes').removeClass("no-bottom-border");

    // make sure that SHOW PRODUCTS, not SHOW OUTFITS is highlighted
    $('.show-outfits-or-products').addClass('nonactive');
    $(this).removeClass("nonactive");

    // if a character is selected:
    if ($('.selected').length) {

      // store that character's name
      var character = $('.selected').find('.character-thumbbox-name').text();

      featureList.filter(function(item) {
        // show only PRODUCTS that belong to the character
        if ((item.values().type == "product") && (item.values().character == character)) {
          return true;
        } else {
          return false;
        }
      });

    // if a character is not selected, just show PRODUCTS (all characters)
    } else {
        featureList.filter(function(item) {
        if (item.values().type == "product") {
          return true;
        } else {
          return false;
        }
      });
    }

  });


  // TODO: add this button to the UI
  $('#filter-none').click(function() {
    featureList.filter();
    return false;
  });

    $("ul#show-navigation-top > li").hover(function(){
        $(this).children("div#slide-top").stop().slideToggle("fast");
    });


    $('.tooltip').tooltipster({
      position: 'bottom',
      theme: '.spylight-tooltip-theme',
    });

});

    

