/*jslint nomen: true, regexp: true, unparam: true, sloppy: true, white: true, node: true */
/*global window, console, document, $, jQuery, google */

/*
 * On document ready
 */
$(document).ready(function () {

	/** Custom selectbox */
	$('select').selectric({
		maxHeight: 200,
		disableOnMobile: false,
		responsive: true
	});

	/** Checkbox, Radio */
	$('.checkbox').each(function () {
		$('<span class="square"/>').insertAfter($('input', this));
	});
	$('.radiobox').each(function () {
		if ($('.circle', this).length === 0) {
			$(this).append('<span class="circle"></span>');
		}
	});

	/** Toggle class "checked" in radiobox label */
	$('.form-line-radiobox').on('change', 'label', function () {
		var _self = $(this);
		if ($('input', this).is(':checked')) {
			$(this).addClass('checked').siblings('.checked').removeClass('checked');
		}
	});

	/** Calculate total in message popup */
	$('.popup-message').each(function () {
		var total = $('.total', this);
		$('.radiobox-price', this).on('change', function () {
			var radio = $(':radio', this);
			if (radio.is(':checked')) {
				total.val('$' + radio.val());
			}
		});

	});

	initPopups();
	initForms();
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

};