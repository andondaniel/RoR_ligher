// This stuff pertains to the EPISODE#SHOW page

$(function(){


$('.season-dropdown').hoverIntent(
	function showSeasons() {
		$('.more-seasons').slideToggle();
});

$('.episode-dropdown').hoverIntent(
	function showEpisodes() {
		$('.more-episodes').slideToggle();
	})


});
