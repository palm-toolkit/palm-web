/* global variables */

/* document ready */
$(function(){
	
});



/**
 * POST admin objects via ajax
 */
function postAdminContentViaAjax( url, dataObject, isResultInJSON, containerSelector, alwaysCallback){
	if( typeof dataObject === "undefined")
		dataObject = {};
	
	if( typeof isResultInJSON === "undefined")
		isResultInJSON = false;
	
	var jqxhr = $.post( baseUrl + "/" +  url, dataObject, function( response ) {
		if( typeof containerSelector !== "undefined")
			$( containerSelector ).html( response );
		if( isResultInJSON )
			return response;
	})
    .done(function() {
    	// nothing to do
	})
	.fail(function() {
		// nothing to do
	})
	.always(function() {
		if( typeof alwaysCallback !== "undefined" )
			alwaysCallback
	});
}

/**
 * GET admin content in JSON format via ajax 
 */
function getJSONAdminContentViaAjax( url ){
	var jqxhr = $.getJSON( baseUrl + "/" +  url, function( data ) {
		return data;
	})
    .done(function() {
    	// nothing to do
	})
	.fail(function() {
		// nothing to do
	})
	.always(function() {
		// nothing to do
	});
}