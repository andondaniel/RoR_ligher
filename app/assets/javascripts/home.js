$(function(){

	// This code is for the "View All Jess/Neal" links that are at the bottom of the home page
	$('.view-all').hoverIntent(animateLink, leaveLink);

	  function leaveLink() {
	    $(this).children('.overlay').fadeIn("slow");
	    $(this).children('.text').css("color","white");
	    $(this).children('.text').animate({
	      left: "+=50",
	      color: "white"
	    },1000);
	  }

	  function animateLink() {
	    $(this).children('.overlay').fadeOut("slow");
	    $(this).children('.text').css("color","black");
	    $(this).children('.text').animate({
	      left: "-=50",
	      color: "#FFC909"
	    },1000);
	  }
	
	// When you hover over a outfit product on the landing page, the product fades in to replace the outfit image
  function showProduct() {
    var url = $(this).children('img').attr("src");
    $(this).children('.overlay').hide();
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.image-preview').children('img').attr('src',url);
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.image-preview').children('img').fadeIn();
    var info = $(this).children('.product-info').html();
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.outfit-description').fadeOut();
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.image-preview').children('.product-details').append(info);
  }

  function hideProduct() {
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.image-preview').children('img').attr('src','');
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.image-preview').children('img').hide();
    $('.product-details').empty();
    $(this).parents('.featured-outfit').find('.outfit-pic').children('.outfit-description').show();
    $(this).children('.overlay').show();
  }

  $('.outfit-product').hoverIntent(showProduct,hideProduct);


// If you aren't signed in, the LOGIN quickview appears
  $(function() {
    $('.no-access').click(function(e) {
      if ($('.log-in-status').text() == "no") {
        e.preventDefault();

        function lightboxProduct() {
          $('#login').lightbox_me({
            centered: true,
            zIndex: 100000000,
            closeSelector: ".exit",
          });
        }
        $('#login').change(lightboxProduct());
      };
    });
  });


  // initiates the main jcarousel on the landing page
  $(function() {
    var carousel = $('.jcarousel').jcarousel({
      wrap: 'circular'
        // Core configuration goes here
    })

    $('.jcarousel-prev').jcarouselControl({
        target: '-=1',
        carousel: carousel
    });

    $('.jcarousel-next').jcarouselControl({
        target: '+=1',
        carousel: carousel
    });
  });

});