/*jslint nomen: true, regexp: true, unparam: true, sloppy: true, white: true, node: true */
/*global window, console, document, $, jQuery, google */


/*
 * On document ready
 */
$(document).ready(function () {

	/* Fastclick */
	FastClick.attach(document.body);

	initForms();

	/* Toggle settings dropdown in the header  */
	$('.header').each(function () {
		body = $('body');
		$('.username .switch', this).on('click', function () {
			body.addClass('profile-open').on('click', function () {
				if ($(this).hasClass('profile-visible')) {
					$(this).removeClass('profile-visible');
					setTimeout(function () {
						body.removeClass('profile-open');
					}, 500);
				}
			});
			if (!$('body').is('.profile-visible')) {
				setTimeout(function () {
					body.addClass('profile-visible');
				}, 20);
			} else {
				body.removeClass('profile-visible');
				setTimeout(function () {
					body.removeClass('profile-open');
				}, 500);
			}
			return false;
		});
	});

	/* Tabs */
	$('.tabs', this).each(function () {
		$(this).on('click', 'a', function (event) {
			var where = $(this).attr('href').replace(/^.*#(.*)/, "$1");
			$(this).closest('li').addClass('active').siblings('li.active').removeClass('active');
			$('#' + where).removeClass('tab-hidden').siblings('.tab').addClass('tab-hidden');
			event.preventDefault();
		});
	});

	initPopups();
	initPhotoSwipe('.gallery');
});


/**
 * Init popups
 */
window.initPopups = function (scope) {

	/** On popup opened */
	window.onOpen = function () {
		/** Init inner forms */
		initForms(this.wrap);

		/** Rebind close button */
		$('.js-close', this.wrap).unbind('click').on('click', function (e) {
			$.magnificPopup.close();
			e.preventDefault();
		});

		/** Reset message popup */
		if ($(this.content).hasClass('popup-message')) {
			var total = $('.total', this.content);
			total.val('');

			$('.checkbox-gift', this.content).find(':checkbox').removeAttr('checked');
			$('.radiobox-price', this.content).removeClass('checked').on('change', function () {
				var radio = $(':radio', this);
				if (radio.is(':checked')) {
					$(this).addClass('checked').siblings('.checked').removeClass('checked');
					total.val('$' + radio.val());
				}
			}).find(':radio').removeAttr('checked');
		}

	};

	$('.js-popup').each(function () {
		$(this).magnificPopup({
			type: "inline",
			closeMarkup: '<span title="%title%" class="mfp-close"><span class="mfp-in"></span></span>',
			settings: {cache: false},
			mainClass: 'mfp-zoom-in',
			midClick: true,
			removalDelay: 300,
			autoFocusLast: false,
			callbacks: {
				open: onOpen
			}
		});
	});
};


/**
 * Init forms
 */
window.initForms = function (scope) {
	if (typeof scope === 'undefined') {
		scope = document;
	}

	/** Custom selectbox */
	$('select', scope).selectric({
		maxHeight: 200,
		disableOnMobile: false,
		responsive: true
	});

	/** Checkbox, Radio */
	$('.checkbox:not(.inited)', scope).each(function () {
		$('<span class="square"/>').insertAfter($('input', this));
		$(this).addClass('inited');
	});
	$('.radiobox:not(.inited)', scope).each(function () {
		if ($('.circle', this).length === 0) {
			$(this).append('<span class="circle"></span>');
		}
		$(this).addClass('inited');
	});

};


/**
 * Init photoswipe
 */
window.initPhotoSwipe = function (gallerySelector) {

	// parse slide data (url, title, size ...) from DOM elements
	// (children of gallerySelector)
	var parseThumbnailElements = function (el) {
		var thumbElements = el.childNodes,
			numNodes = thumbElements.length,
			items = [],
			figureEl,
			linkEl,
			size,
			item;

		for (var i = 0; i < numNodes; i++) {

			figureEl = thumbElements[i]; // <figure> element

			// include only element nodes
			if (figureEl.nodeType !== 1) {
				continue;
			}

			linkEl = figureEl.children[0]; // <a> element

			size = linkEl.getAttribute('data-size').split('x');

			// create slide object
			item = {
				src: linkEl.getAttribute('href'),
				w: parseInt(size[0], 10),
				h: parseInt(size[1], 10)
			};


			if (figureEl.children.length > 1) {
				// <figcaption> content
				item.title = figureEl.children[1].innerHTML;
			}

			if (linkEl.children.length > 0) {
				// <img> thumbnail element, retrieving thumbnail url
				item.msrc = linkEl.children[0].getAttribute('src');
			}

			item.el = figureEl; // save link to element for getThumbBoundsFn
			items.push(item);
		}

		return items;
	};

	// find nearest parent element
	var closest = function closest(el, fn) {
		return el && ( fn(el) ? el : closest(el.parentNode, fn) );
	};

	// triggers when user clicks on thumbnail
	var onThumbnailsClick = function (e) {
		e = e || window.event;
		e.preventDefault ? e.preventDefault() : e.returnValue = false;

		var eTarget = e.target || e.srcElement;

		// find root element of slide
		var clickedListItem = closest(eTarget, function (el) {
			return (el.tagName && el.tagName.toUpperCase() === 'FIGURE');
		});

		if (!clickedListItem) {
			return;
		}

		// find index of clicked item by looping through all child nodes
		// alternatively, you may define index via data- attribute
		var clickedGallery = clickedListItem.parentNode,
			childNodes = clickedListItem.parentNode.childNodes,
			numChildNodes = childNodes.length,
			nodeIndex = 0,
			index;

		for (var i = 0; i < numChildNodes; i++) {
			if (childNodes[i].nodeType !== 1) {
				continue;
			}

			if (childNodes[i] === clickedListItem) {
				index = nodeIndex;
				break;
			}
			nodeIndex++;
		}


		if (index >= 0) {
			// open PhotoSwipe if valid index found
			openPhotoSwipe(index, clickedGallery);
		}
		return false;
	};

	// parse picture index and gallery index from URL (#&pid=1&gid=2)
	var photoswipeParseHash = function () {
		var hash = window.location.hash.substring(1),
			params = {};

		if (hash.length < 5) {
			return params;
		}

		var vars = hash.split('&');
		for (var i = 0; i < vars.length; i++) {
			if (!vars[i]) {
				continue;
			}
			var pair = vars[i].split('=');
			if (pair.length < 2) {
				continue;
			}
			params[pair[0]] = pair[1];
		}

		if (params.gid) {
			params.gid = parseInt(params.gid, 10);
		}

		return params;
	};

	var openPhotoSwipe = function (index, galleryElement, disableAnimation, fromURL) {
		var pswpElement = document.querySelectorAll('.pswp')[0],
			gallery,
			options,
			items;

		items = parseThumbnailElements(galleryElement);

		// define options (if needed)
		options = {

			// define gallery index (for URL)
			galleryUID: galleryElement.getAttribute('data-pswp-uid'),

			getThumbBoundsFn: function (index) {
				// See Options -> getThumbBoundsFn section of documentation for more info
				var thumbnail = items[index].el.getElementsByTagName('img')[0], // find thumbnail
					pageYScroll = window.pageYOffset || document.documentElement.scrollTop,
					rect = thumbnail.getBoundingClientRect();

				return {x: rect.left, y: rect.top + pageYScroll, w: rect.width};
			}

		};

		// PhotoSwipe opened from URL
		if (fromURL) {
			if (options.galleryPIDs) {
				// parse real index when custom PIDs are used
				// http://photoswipe.com/documentation/faq.html#custom-pid-in-url
				for (var j = 0; j < items.length; j++) {
					if (items[j].pid == index) {
						options.index = j;
						break;
					}
				}
			} else {
				// in URL indexes start from 1
				options.index = parseInt(index, 10) - 1;
			}
		} else {
			options.index = parseInt(index, 10);
		}

		// exit if index not found
		if (isNaN(options.index)) {
			return;
		}

		if (disableAnimation) {
			options.showAnimationDuration = 0;
		}

		// Pass data to PhotoSwipe and initialize it
		gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, items, options);
		gallery.init();
	};

	// loop through all gallery elements and bind events
	var galleryElements = document.querySelectorAll(gallerySelector);

	for (var i = 0, l = galleryElements.length; i < l; i++) {
		galleryElements[i].setAttribute('data-pswp-uid', i + 1);
		galleryElements[i].onclick = onThumbnailsClick;
	}

	// Parse URL and open gallery if it contains #&pid=3&gid=1
	var hashData = photoswipeParseHash();
	if (hashData.pid && hashData.gid) {
		openPhotoSwipe(hashData.pid, galleryElements[hashData.gid - 1], true, true);
	}
};