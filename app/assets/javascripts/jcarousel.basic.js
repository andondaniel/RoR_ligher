// (function($) {
//     $(function() {
//         $('.jcarousel').jcarousel();

//         $('.jcarousel-control-prev')
//             .on('active.jcarouselcontrol', function() {
//                 $(this).removeClass('inactive');
//             })
//             .on('inactive.jcarouselcontrol', function() {
//                 $(this).addClass('inactive');
//             })
//             .jcarouselControl({
//                 target: '-=1'
//             });

//         $('.jcarousel-control-next')
//             .on('active.jcarouselcontrol', function() {
//                 $(this).removeClass('inactive');
//             })
//             .on('inactive.jcarouselcontrol', function() {
//                 $(this).addClass('inactive');
//             })
//             .jcarouselControl({
//                 target: '+=1'
//             });

//         $('.jcarousel-pagination')
//             .on('active.jcarouselpagination', 'a', function() {
//                 $(this).addClass('active');
//             })
//             .on('inactive.jcarouselpagination', 'a', function() {
//                 $(this).removeClass('active');
//             })
//             .jcarouselPagination();
//     });
// })(jQuery);

(function($) {

    $(function() {
        
        $('.outfit-carousel').jcarousel();

        $('.outfit-control-prev')
            .on('active.jcarouselcontrol', function() {
                $(this).removeClass('inactive');
            })
            .on('inactive.jcarouselcontrol', function() {
                $(this).addClass('inactive');
            })
            .jcarouselControl({
                target: '-=3'
            });

        $('.outfit-control-next')
            .on('active.jcarouselcontrol', function() {
                $(this).removeClass('inactive');
            })
            .on('inactive.jcarouselcontrol', function() {
                $(this).addClass('inactive');
            })
            .jcarouselControl({
                target: '+=3'
            });

        $('.jcarousel-pagination')
            .on('active.jcarouselpagination', 'a', function() {
                $(this).addClass('active');
            })
            .on('inactive.jcarouselpagination', 'a', function() {
                $(this).removeClass('active');
            })
            .jcarouselPagination();
    });
})(jQuery);