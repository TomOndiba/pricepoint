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

});
