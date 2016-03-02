/**
 * Main JS file for theme behaviours
 */

/*globals jQuery, document */
(function ($) {

    $(document).ready(function(){

		//expand width of prev-post if next-post doesn't exist
		if ( $('.read-next .next-post').length == 0 ){
		    $('.read-next .prev-post').addClass('single-story');
		}
		//expand width of next-post if prev-post doesn't exist
		if ( $('.read-next .prev-post').length == 0 ){
		    $('.read-next .next-post').addClass('single-story');
		}

		/* Responsive Videos */
        function fitVidInit(){
            $(".post-content").fitVids();
        }
        
        fitVidInit();

		/* Disqus Comments */
        if(disqus){
            $('.show-comments').on('click', function(){
              var disqus_shortname = disqus;
              var disqus_identifier = '{{post.id}}'; //avoid any issues caused by post URLs changing
            
              //ajax request to load the disqus javascript
              $.ajax({
                      type: "GET",
                      url: "https://" + disqus_shortname + ".disqus.com/embed.js",
                      dataType: "script",
                      cache: true
              });
              //hide the button once comments load
              $(this).fadeOut();
            });
        }else{
            $('.comments').css('display', 'none');
        }

        /* Image lightbox */
        if(lightbox == true && !Modernizr.touch){
            $('.post-template .post-content img').each(function (){
                var currentImg = $(this);
                //currentImg.wrap("<div class='full-width' >"); //full width images
                currentImg.wrap("<a class='image-popup' href='" + currentImg.attr("src") + "' />");
            });
            
            $('.image-popup').magnificPopup({
                type: 'image',
                closeOnContentClick: true,
                closeBtnInside: false,
                fixedContentPos: true,
                mainClass: 'mfp-no-margins mfp-with-zoom', // class to remove default margin from left and right side
                image: {
                    verticalFit: true
                },
                zoom: {
                    enabled: true,
                    duration: 300 // don't foget to change the duration also in CSS
                }
            });

        }

        /* Infinite Scroll */
        if(infinite_scroll == 'scroll'){

            var ias = $.ias({
                container:  "#main",
                item:       ".post",
                pagination: "#pagination",
                next:       ".older-posts"
            });

            ias.extension(new IASSpinnerExtension()); 
            ias.extension(new IASPagingExtension());
            ias.extension(new IASHistoryExtension());

            ias.on('rendered', function(items) {
                fitVidInit();
            })

        }else if(infinite_scroll == 'click'){

            var ias = $.ias({
                container:  "#main",
                item:       ".post",
                pagination: "#pagination",
                next:       ".older-posts"
            });

            ias.extension(new IASTriggerExtension({
                text: 'More Stories',
                html: '<div class="pagination"><a class="load-more-posts">{text}</a></div>',
                htmlPrev: " "
            }));

            ias.extension(new IASPagingExtension());
            ias.extension(new IASHistoryExtension());


            ias.on('rendered', function(items) {
                fitVidInit();
            })

        }

        /* Social Media Icons */

        //show icons once JS has loaded
        $(".social").css('visibility', 'visible');

        if(facebook_link){
            $(".social .facebook").attr("href", facebook_link);
        }else{
            $(".social .facebook").css("display", "none");
        }

        if(twitter_link){
            $(".social .twitter").attr("href", twitter_link);
        }else{
            $(".social .twitter").css("display", "none");
        }

        if(google_plus_link){
            $(".social .google-plus").attr("href", google_plus_link);
        }else{
            $(".social .google-plus").css("display", "none");
        }

        if(dribbble_link){
            $(".social .dribbble").attr("href", dribbble_link);
        }else{
            $(".social .dribbble").css("display", "none");
        }

        if(instagram_link){
            $(".social .instagram").attr("href", instagram_link);
        }else{
            $(".social .instagram").css("display", "none");
        }

        if(tumblr_link){
            $(".social .tumblr").attr("href", tumblr_link);
        }else{
            $(".social .tumblr").css("display", "none");
        }

        if(youtube_link){
            $(".social .youtube").attr("href", youtube_link);
        }else{
            $(".social .youtube").css("display", "none");
        }

        if(vimeo_link){
            $(".social .vimeo").attr("href", vimeo_link);
        }else{
            $(".social .vimeo").css("display", "none");
        }

        if(pinterest_link){
            $(".social .pinterest").attr("href", pinterest_link);
        }else{
            $(".social .pinterest").css("display", "none");
        }

        if(flickr_link){
            $(".social .flickr").attr("href", flickr_link);
        }else{
            $(".social .flickr").css("display", "none");
        }

        if(linkedin_link){
            $(".social .linkedin").attr("href", linkedin_link);
        }else{
            $(".social .linkedin").css("display", "none");
        }

        if(github_link){
            $(".social .github").attr("href", github_link);
        }else{
            $(".social .github").css("display", "none");
        }

        if(rss_link == false){
            $(".social .rss").css("display", "none");
        }

	});

}(jQuery));