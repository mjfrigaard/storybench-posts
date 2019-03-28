
;(function($) {

   'use strict'

	var responsiveMenu = function() {
		var	menuType = 'desktop';

		$(window).on('load resize', function() {
			var currMenuType = 'desktop';

			if ( matchMedia( 'only screen and (max-width: 991px)' ).matches ) {
				currMenuType = 'mobile';
			}

			if ( currMenuType !== menuType ) {
				menuType = currMenuType;

				if ( currMenuType === 'mobile' ) {
					var $mobileMenu = $('#mainnav').attr('id', 'mainnav-mobi').hide();
					var hasChildMenu = $('#mainnav-mobi').find('li:has(ul)');

					hasChildMenu.children('ul').hide();
					hasChildMenu.children('a').after('<span class="btn-submenu"></span>');
					$('.btn-menu').removeClass('active');
				} else {
					var $desktopMenu = $('#mainnav-mobi').attr('id', 'mainnav').removeAttr('style');

					$desktopMenu.find('.sub-menu').removeAttr('style');
					$('.btn-submenu').remove();
				}
			}
		});

		$('.btn-menu').on('click', function() {
			$('#mainnav-mobi').slideToggle(300);
			$(this).toggleClass('active');
		});

		$(document).on('click', '#mainnav-mobi li .btn-submenu', function(e) {
			$(this).toggleClass('active').next('ul').slideToggle(300);
			e.stopImmediatePropagation()
		});
	}

    var responsiveVideo = function(){
        if ( $().fitVids ) {
            $('body').fitVids();
        }
    };

    var tabs = function() {
        $('.tabs').each(function() {
        	var el = $(this);
            el.find('.content').hide();
            el.find('.menu-tab > li').on('click', function(e) {
				var liActive = $(this).index();
				var contentActive = $(this).parents('.tabs').find('.content').eq(liActive);

				$(this).addClass('active').siblings().removeClass('active');
				contentActive.fadeIn().siblings().hide();

				e.preventDefault();
            }).filter('.active').trigger('click');
        });
    };

    var postsCarousel = function() {
        if ( $().owlCarousel ) {
            var container = $('.roll-posts-carousel');
            var imgLoad = imagesLoaded(container);
            imgLoad.on( 'always', function() {
                container.each(function(){
                        var $this = $(this);
                        $this.find('.owl-carousel').owlCarousel({
                            autoplay: $this.data('auto'),
                            loop: true,
                            margin: 30,
                            dots: false,
                            nav: true,
                            autoplayTimeout: $this.data('speed'),
                            autoHeight: true,
                            navText: [ '<i class="fa fa-arrow-left"></i>', '<i class="fa fa-arrow-right"></i>' ],
                            responsive:{
                            0:{
                                items: 1
                            },
                            480:{
                                items: 2
                            },
                            991:{
                                items: $this.data('items')
                            }
                        }
                    });
                });
            });
        } // end if
    };

    var goTop = function() {
        $(window).scroll(function() {
            if ( $(this).scrollTop() > 600 ) {
                $('.go-top').addClass('show');
            } else {
                $('.go-top').removeClass('show');
            }
        }); 

        $('.go-top, .go-top2').on('click', function() {
            $("html, body").animate({ scrollTop: 0 }, 1000);
            return false;
        });

		$(window).on('load scroll', function() {
		    $('.go-top2').each(function(e) {
		    	if ( this.getBoundingClientRect().top < $(window).height() ) {
		    		$('.go-top').addClass('hide');
		    		$('.go-top2').addClass('show');
		    	} else {
		    		$('.go-top').removeClass('hide');
		    		$('.go-top2').removeClass('show');
		    	}
		    })
		}) 
    };

    var removePreloader = function() {
		$('.preloader').css('opacity', 0);
		setTimeout(function(){$('.preloader').hide();}, 600);	
    }


	// DOM Ready
	$(function() {
		responsiveMenu();
        responsiveVideo();
        tabs();
        goTop();     
        postsCarousel();
        removePreloader();
	});

})(jQuery);