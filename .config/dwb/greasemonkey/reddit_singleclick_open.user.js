// ==UserScript==
// @name           Reddit SingleClick Opener
// @require        http://code.jquery.com/jquery-1.3.2.min.js
// @namespace      http://www.reddit.com/
// @description    Tags Reddit posts with Subreddit prefixes
// @include        http://www.reddit.com/
// @include        http://www.reddit.com/r/*/
// @exclude        http://www.reddit.com/r/*/comments*
// ==/UserScript==


count = 0;
$('#siteTable .entry').each(function() {
	count++;
	thisLink = $(this).find('A.title').attr('href');
	thisComments = $(this).find('.comments').attr('href');
	$(this).find('.flat-list').append('<li><a class="redditSingleClick" style="padding-left: 5px; color: #602020;" href="' + thisLink + '">both</a></li>');
	thisDomain = $(this).find('.domain').text();
	$(this).find('.redditSingleClick').attr('thisLink', thisLink);
	if (thisDomain.substr(1,4) != 'self') {
		$(this).find('.redditSingleClick').attr('thisComments', thisComments);
	}
});
$('.redditSingleClick').on("click", function(e) {
	e.preventDefault();
	if ($(this).attr('thisComments')) {
		window.open($(this).attr('thisComments'));
	}
	window.open($(this).attr('thisLink'));
	return false;
});
