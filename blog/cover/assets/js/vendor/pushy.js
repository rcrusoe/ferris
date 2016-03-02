/*! Pushy Slim - v1.0.0 - 2014-10-12
* Pushy is a responsive off-canvas navigation menu using CSS transforms & transitions.
* This custom version is removes IE fallback and adds an animated menu icon (Material Hamburger)
* https://github.com/christophery/pushy/
* by Christopher Yee */

$(function() {
	var pushy = $('.pushy'), //menu css class
		body = $('body'),
		container = $('#main'), //container css class
		push = $('.push'), //css class to add pushy capability
		siteOverlay = $('.site-overlay'), //site overlay
		pushyClass = "pushy-left pushy-open", //menu position & menu open class
		pushyActiveClass = "pushy-active", //css class to toggle site overlay
		menuBtn = $('.menu-btn, .pushy a'), //css classes to toggle the menu
		containerClass = "container-push", //container open class
		pushClass = "push-push", //css class to add pushy capability
		menuIcon = $('.material-burger'), //menu icon
		menuTransform = "material-burger-transformed"; //menu transform class

	function togglePushy(){
		body.toggleClass(pushyActiveClass); //toggle site overlay
		pushy.toggleClass(pushyClass);
		menuIcon.toggleClass(menuTransform);
		container.toggleClass(containerClass);
		push.toggleClass(pushClass); //css class to add pushy capability
	}

	//toggle menu
	menuBtn.click(function() {
		togglePushy();
	});

	//close menu when clicking site overlay
	siteOverlay.click(function(){ 
		togglePushy();
	});

});