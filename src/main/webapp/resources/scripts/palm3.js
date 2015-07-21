/* global variables */

/* document ready */
$(function(){
	$( "#signin_button" ).click( function( event ){
		event.preventDefault();
		// get login form
		getFormViaAjax( "login" );
	});
	
});

/**
 * get form via ajax
 */
function getFormViaAjax( formType , alwaysCallback){
	var jqxhr = $.get( baseUrl + "/" +  formType, function( html ) {
		getPopUpForm(  formType, html );
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
 * Get popup form and display it
 */
function getPopUpForm( popUpType, html ){
	// remove existing popup if exist
	$( ".popup-form-container" ).remove();
	/* add blur */
	$( ".wrapper" ).addClass( "blur2px" );
	
	// create new one
	$popUpElem = 
		$( "<div/>" )
		.addClass( "popup-form-container" )
		.append(
				$( "<div/>" )
				.addClass( "dialog-overlay" )
				)
		.append(
				$( "<div/>" )
				.addClass( popUpType + "-container" )
				.html( html )
				)
		.appendTo( "body" );
}




/* jQuery ajax get */
function getContentViaAjax( url, containerSelector ){
	/* add loading image on container first*/
	$( containerSelector ).addClass( "ajax-loading-image" );
	/* get the content*/
	var jqxhr = $.ajax( url )
	  .done(function( html ) {
	    $( containerSelector ).html( html );
	  })
	  .fail(function() {
	  })
	  .always(function() {
		  $( containerSelector ).removeClass( "ajax-loading-image" );
	  });
}

function getDialogOptions( dialogTitle, dialogWidth, dialogHeight, isModal, isResizeble, isDraggable, buttonSelector){
	if( typeof isModal == "undefined" )
		isModal = false;
	if( typeof isResizeble == "undefined" )
		isResizeble = true;
	if( typeof isModal == "undefined" )
		isDraggable = true;
	    //dialog options
	    var dialogOptions = {
	      "title" : dialogTitle,
	      "width" : dialogWidth,
	      "height" : dialogHeight,
	      "modal" : isModal,
	      "resizable" : isResizeble,
	      "draggable" : isDraggable,
	      "close" : function(){
	    	  $(buttonSelector).removeClass( "current" );
      }
	    };
	    return dialogOptions;
}

function getDialogExtendOptions( isClosable, isMaximizable, isMinimizable){
	if( typeof isClosable == "undefined" )
		isClosable = true;
	if( typeof isMaximizable == "undefined" )
		isMaximizable = true;
	if( typeof isMinimizable == "undefined" )
		isMinimizable = true;
	// dialog-extend options
    var dialogExtendOptions = {
      "closable" : isClosable,
      "maximizable" : isMaximizable,
      "minimizable" : isMinimizable,
      "minimizeLocation" : "left",
      "collapsable" : true,
      "dblclick" : "collapse",
      "titlebar" : false
	};
    return dialogExtendOptions;
}

/**
 * Convert any input type files into jquery multiple file upload
 * $fileSelector - required - the input files must be jquery object
 * $progressSelector - required - the progress bar must be jquery object
 */
function convertToAjaxMultipleFileUpload( $inputFile, $progressBar , $resultContainer){
	var $container = null;
	if ($resultContainer instanceof jQuery)
		$container = $resultContainer;
	else
		$container = $( $resultContainer );
	
	$inputFile.fileupload({
        dataType: 'json',
 
        done: function (e, data) {
        	printUploadedArticles( $container, data.result , []);
        },
 
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $progressBar.find('.bar').css('width', progress + '%').html( progress + '%');
            $progressBar.show();
            if( progress == 100 )
            	window.setTimeout( function(){$progressBar.fadeOut( "slow" ); } , 3000);
        }
    });
}

function printUploadedArticles( $containerSelector, data , addedOptions){
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $( $containerSelector );
	
	/* check if textarea available*/
	if( $container.find( "textarea" ).length == 0){
		$container
			.append( $('<textarea/>')
					.css({'width': '99%', 'height' : "410px", 'resize' : ' none'})
					)
			.css({'width': '100%', 'height' : "450px"})
			.resizable({
			  resize: function( event, ui ) {
				  $( this ).find( "textarea" )
				  .css({ 'width' : (ui.element.width() - 10 ) + 'px' , 'height' : (ui.element.height() - 40 ) + 'px' });
			  }
			});
	}
	
	var textareaVal = $container.find( "textarea" ).val();
	var appendedVal = "uploaded " + data.id + " \t " + data.title + "\n";
	
	$container.find( "textarea" ).val( textareaVal + appendedVal );
	
}