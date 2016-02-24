/*jslint nomen: true, regexp: true, unparam: true, sloppy: true, white: true, node: true */
/*global window, console, document, $, jQuery, google */


/**
 * On document ready
 **/
$(document).ready(function () {
	initUI();
	initForms();
});


/**
 * Init UI
 **/
function initUI() {
	/** Fastclick */
	FastClick.attach(document.body);

	/** Toggle settings dropdown in the header  */
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

	/** Tabs */
	$('.tabs').each(function () {
		$(this).on('click', 'a', function (event) {
			var where = $(this).attr('href').replace(/^.*#(.*)/, "$1");
			$(this).closest('li').addClass('active').siblings('li.active').removeClass('active');
			$('#' + where).removeClass('tab-hidden').siblings('.tab').addClass('tab-hidden');
			event.preventDefault();
		});
	});

	/** Init popups */
	$('.js-popup').magnificPopup({
		type: 'ajax',
		closeMarkup: '<span title="%title%" class="mfp-close"><span class="mfp-in"></span></span>',
		settings: {cache: false},
		mainClass: 'mfp-zoom-in',
		midClick: true,
		removalDelay: 300,
		autoFocusLast: false,
		callbacks: {
			ajaxContentAdded: function () {
				initForms(this.content, this);
			}
		}
	});

	/** Init favorite */
	$('.js-favorite').on('click', function (event) {
		var self = $(this);
		var request = sendRequest({'Favorite': {'id_user': self.closest('[data-id]').data('id'), 'on_off': self.hasClass('active')}});
		self.toggleClass('active');
		request.done(function (data) {
			alert(data);
		});
		event.preventDefault();
	});

	initPhotoSwipe('.my-gallery');
}


/**
 * Init forms
 **/
function initForms(scope, data) {
	if (typeof scope === 'undefined') {
		scope = document;
	}

	/** Custom selectbox */
	$('select.select', scope).selectric({
		maxHeight: 200,
		disableOnMobile: false,
		responsive: true
	});

	/** Multiselect selectbox */
	$('select.multiselect', scope).each(function () {
		$(this).multiselect({
			nonSelectedText: $(this).data('title'),
			allSelectedText: $(this).data('all'),
			numberDisplayed: 10
		})
	});

	/** Multiselect dropdown */
	$('.btn-group', scope).each(function () {
		function Handler(event) {
			var c = $(event.target).closest(st);
			if ((c.length === 0)) {
				Hide();
			}
		}

		function Show() {
			Hide();
			self.addClass('open');
			body.on('click', Handler);
		}

		function Hide() {
			body.off('click', Handler);
			buttons.filter('.open').removeClass('open');
		}

		var self = $(this), body = $('body'), st = '.btn-group', buttons = $(st);
		$('.radio', self).on('click', function (event) {
			if ($(this).closest('.active').length > 0) {
				Hide();
			}
			event.stopPropagation();
		});
		$('.dropdown-toggle,.toggle', self).on('click', function () {
			if (!self.hasClass('open')) {
				Show();
			} else {
				Hide();
			}
		})
	});

	/** Radiobox init */
	$('.checkbox:not(.inited)', scope).each(function () {
		$('<span class="square"/>').insertAfter($('input', this));
		$(this).addClass('inited');
	});

	/** Checkbox init */
	$('.radio:not(.inited)', scope).each(function () {
		if ($('.circle', this).length === 0) {
			$(this).append('<span class="circle"></span>');
		}
		$(this).addClass('inited');
	});

	/** Select age dropdown */
	$('.select-age:not(.inited)', scope).each(function () {
		var self = $(this);
		$('input:text', self).on('keypress', function (event) {
			return event.charCode >= 48 && event.charCode <= 57;
		}).on('change', function () {
			$('.' + $(this).attr('name'), self).text($(this).val());
		});
		self.addClass('inited');
	});

	/** Filter form */
	$('.form-filter:not(.inited)', scope).each(function () {
		var result = {};
		$(this).on('submit', function () {
			$('[required]', this).each(function () {
				if ($(this).is('[multiple]') && $(this).val() === null) {
					result[$(this).attr('name')] = [];
				} else {
					result[$(this).attr('name')] = $(this).val();
				}
			});
			alert(JSON.stringify(result, null, 4));
			return false;
		}).addClass('inited');
	});

	/** Offer form */
	$('.form-offer:not(.inited)', scope).each(function () {
		/** Clear form*/
		function Clear() {
			total.val('');
			gifts.removeAttr('checked').closest('label').removeClass('checked');
			offers.removeAttr('checked').closest('label').removeClass('checked');
		}

		var form = $(this),
			total = $('.total', form), username = $('.username', form),
			gifts = $('.checkbox-gift :checkbox', form), offers = $('.radio-offer :radio', form),
			el = $(data.items[data.index].el), item = el.closest('[data-id]');

		username.text(item.data('user'));

		offers.each(function () {
			var radio = $(this);
			radio.on('change', function () {
				if (radio.is(':checked')) {
					radio.closest('label').addClass('checked').siblings('.checked').removeClass('checked');
					total.val('$' + radio.val());
				}
			});
		});

		total.on('keypress', function (event) {
			return event.charCode >= 48 && event.charCode <= 57;
		}).on('change', function () {
			if (total.val().indexOf('$') < 0) {
				total.val('$' + total.val());
			}
		});

		form.on('submit', function () {
			var i = item.data('id'),
				t = +total.val().replace('$', ''),
				g = [], gs = '';
			gifts.filter(':checked').each(function () {
				g.push(+$(this).val());
			});
			if ((t > 500)) {
				$('button', form).blur();
				alert('Your offer must be $500 or less');
			} else {
				var request = sendRequest({'MakeOffer': {'id_user': i, 'amount': t, 'gifts': g}});
				request.done(function (data) {
					alert(data);
				});
				var h = el.addClass('hidden').siblings('.sent').removeClass('hidden');
				if (t > 0) {
					h.text('$' + t + ' Offer Sent');
				} else {
					h.text('Offer Sent');
				}
				$.magnificPopup.close();
			}
			return false;
		}).addClass('inited');

		Clear();
	});

	/** Message form */
	$('.form-message:not(.inited)', scope).each(function () {
		var result = {};
		$(this).on('submit', function () {
			$('[required]', this).each(function () {
				result[$(this).attr('name')] = $(this).val()
			});
			result['gifts'] = [];
			$('.checkbox-gift :checkbox', this).filter(':checked').each(function () {
				result['gifts'].push($(this).val());
			});
			alert(JSON.stringify(result, null, 4));
			return false;
		}).addClass('inited');
	});
}

function sendRequest(data) {
	return request = $.ajax({
		url: 'webservice.php',
		method: 'POST',
		data: data,
		context: document.body
	});
}


/**
 * Init photo swipe
 **/
function initPhotoSwipe(gallerySelector) {

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
			childNodes = $('[data-pswp-uid=' + $(clickedListItem.parentNode).attr('data-pswp-uid') + ']').find('figure'),
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

		items = [];
		$('[data-gallery=' + $(galleryElement).data('gallery') + ']').each(function () {
			items = items.concat(parseThumbnailElements(this));
		});

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
	$(gallerySelector).each(function (i) {
		$(this).attr('data-pswp-uid', 1).on('click', onThumbnailsClick);
	});

	// Parse URL and open gallery if it contains #&pid=3&gid=1
	var hashData = photoswipeParseHash();
	if (hashData.pid && hashData.gid) {
		openPhotoSwipe(hashData.pid, $(gallerySelector)[hashData.gid - 1], true, true);
	}
}