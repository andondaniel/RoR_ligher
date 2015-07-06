(function($) {
  $(function() {
      /*
      Carousel initialization
      */
      $('.quiz-carousel')
          .jcarousel({
              // Options go here
          });

      /*
       Prev control initialization
       */
      $('.previous-btn')
          .on('jcarouselcontrol:active', function() {
              $(this).removeClass('inactive');
          })
          .on('jcarouselcontrol:inactive', function() {
              $(this).addClass('inactive');
          })
          .jcarouselControl({
              // Options go here
              target: '-=1'
          });

      /*
       Next control initialization
       */
      $('.next-btn')
          .on('jcarouselcontrol:active', function() {
              $(this).removeClass('inactive');
          })
          .on('jcarouselcontrol:inactive', function() {
              $(this).addClass('inactive');
          })
          .jcarouselControl({
              // Options go here
              target: '+=1'
          });

  });


})(jQuery);


$(document).ready(function() {

    // When a user makes a selection, the rest of the options fade away and the selected item is outlined in black.
    $('.choice').click(function(){
      if ($(this).parent('.choices').children('.chosen').length) {
        $(this).parent('.choices').children('.chosen').removeClass('chosen');
        $(this).removeClass('not-chosen');
      }

      $(this).addClass('chosen');
      $(this).siblings().addClass('not-chosen');
      var done = $(this).parents('li').children('.done')
      $(done).addClass('next-btn');

      $('.next-btn')
          .on('jcarouselcontrol:active', function() {
              $(this).removeClass('inactive');
          })
          .on('jcarouselcontrol:inactive', function() {
              $(this).addClass('inactive');
          })
          .jcarouselControl({
              // Options go here
              target: '+=1'
          });
    });

      var firstchoice = [];
      var secondchoice = [];
      var thirdchoice = [];
      var fourthchoice = [];
      var fifthchoice = [];


      // based on the answer, click on a certain hidden link on the page.
      
    $('.show-results').click(function(){

      // find all instances of .chosen in the quiz, for each, do
      $(this).parents('.quiz-carousel').find('.chosen').map(function(){
        // if it is choice-1, then add it to the first choice array.
        if ($(this).hasClass('choice-1')) {
          firstchoice.push("yo");
        } else {
          if ($(this).hasClass('choice-2')) {
          secondchoice.push("yo");
          } else {
            if ($(this).hasClass('choice-3')) {
              thirdchoice.push('yo');
            } else {
                if ($(this).hasClass('choice-4')) {
                  fourthchoice.push('yo');
                } else {
                    if ($(this).hasClass('choice-5')) {
                    fifthchoice.push('yo');
                    } else {
                    return false
                    }
                }
              }
            
          }

        }
        
      });

      
      // create a hash for the choice name and their lengths
      // CUSTOMIZE_QUIZ: change the "choice" for each option
      var h = [
        { choice: "1", length: firstchoice.length },
        { choice: "2", length: secondchoice.length },
        { choice: "3", length: thirdchoice.length },
        { choice: "4", length: fourthchoice.length },
        { choice: "5", length: fifthchoice.length }
      ]

      var a = h.sort(function(obj1, obj2) {
      // Ascending: first age less than the previous
        return obj1.length - obj2.length;
      });

      // Returns:  
        // [
        //    { choice: "fourthchoice", length: 0 },
        //    { choice: "secondchoice", length: 1  },
        //    { name: "firstchoice", length: 2 }
        // ...etc!
        // ]

      // takes the last object in the array and retrieves the name.
      // firstchoice, etc each corresponds to a hidden div (result-1, result-2...) in quiz.html.haml
      // take ANSWER, and show the corresponding div (eg #result)

      var answer = a.pop().choice;
      
      window.location.replace("/results/" + answer);
    });
});





