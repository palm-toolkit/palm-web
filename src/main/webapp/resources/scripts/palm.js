var snorqlDialog, analyticsDialog;

$(function(){
	/* search button pressed */
	$( "#fulltext-search,#tfidf-search,#topic-search" ).click( function( event){
		/* toggle button */
		if( $( this ).hasClass( "current" ) )
			$( this ).removeClass( "current" ).removeClass( "search-current" );
		else
			$( this) .addClass( "current" ).addClass( "search-current" );
		/* toggle input search */
		if( $( ".search-button.current" ).length > 0 )
			$( "#search_box" ).removeClass( "invisible" );
		else
			$( "#search_box" ).addClass( "invisible" );
	});
	
	/* Snorql button pressed */
	$("#snorql-button").click( function( event ){
		if( typeof snorqlDialog == "undefined" ){
			/* add pressed style */
			$( this ).addClass( "current" );
			/* get the content via ajax */
			//getContentViaAjax( baseUrl + "/sparqlview", "#dialog-snorql" );
			$("#dialog-snorql").append(
				$("<iframe />")
					.attr({
						"id": "snorqliframe",
						"src":  baseUrl + "/sparqlview",
						"width": 1024,
						"height":465,
						"frameborder":0
						})
					.addClass("dialog-iframe")
			);
			/* open dialog box */
			var dialogOptions = getDialogOptions("Linked Data Explore", 1024, 500, false, true, true, "#snorql-button");
			var dialogExtendOptions = getDialogExtendOptions(true, false);
			snorqlDialog = 
				$( "#dialog-snorql" )
					.dialog( dialogOptions )
					.dialogExtend( dialogExtendOptions );
			
			snorqlDialog.dialogExtend( "restore" );
			/* adjust iframe size*/
			$( "#dialog-snorql" ).on( "dialogresizestop", function( event, ui ) {
				$("iframe").width( ui.size.width ).height( ui.size.height - 30 );
			} );
			
			/* prevent default behaviour of a link */
			event.preventDefault();
		} else{
			if( snorqlDialog.dialogExtend( "state" )  == "minimized" )
				snorqlDialog.dialogExtend( "restore" );
			else{
				/* add pressed style */
				$( this ).addClass( "current" );
				snorqlDialog.dialog('open');
			}
		}
	});
	
	/* Analytics button pressed */
	$("#analytics-button").click( function( event ){
		if( typeof analyticsDialog == "undefined" ){
			/* add pressed style */
			$( this ).addClass( "current" );
			/* get the content via ajax */
			//getContentViaAjax( baseUrl + "/sparqlview", "#dialog-snorql" );
			$("#dialog-analytics").append(
				$("<iframe />")
					.attr({
						"id": "analyticsiframe",
						"src":  baseUrl + "/analytics/dialog",
						"width": 1024,
						"height":465,
						"frameborder":0
						})
					.addClass("dialog-iframe")
			);
			/* open dialog box */
			var dialogOptions = getDialogOptions("Analytics", 1024, 500, false, true, true, "#analytics-button");
			var dialogExtendOptions = getDialogExtendOptions(true, false);
			analyticsDialog = 
				$( "#dialog-analytics" )
					.dialog( dialogOptions )
					.dialogExtend( dialogExtendOptions );
			
			analyticsDialog.dialogExtend( "restore" );
			/* adjust iframe size*/
			$( "#dialog-analytics" ).on( "dialogresizestop", function( event, ui ) {
				$("iframe").width( ui.size.width ).height( ui.size.height - 30 );
			} );
			
			/* prevent default behaviour of a link */
			event.preventDefault();
		} else{
			if( analyticsDialog.dialogExtend( "state" )  == "minimized" )
				analyticsDialog.dialogExtend( "restore" );
			else{
				/* add pressed style */
				$( this ).addClass( "current" );
				analyticsDialog.dialog('open');
			}
		}
	});
});

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
		$container = $jQ( $resultContainer );
	
	// get remove files url from input element attribute "data-remove-url"
	var fileRemoveUrl = $inputFile.attr( "data-remove-url" );
	
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
		$container = $jQ( $containerSelector );
	
	/* check if textarea available*/
	if( $container.find( "textarea" ).length == 0){
		$container
			.append( $jQ('<textarea/>')
					.css({'width': '99%', 'height' : "410px", 'resize' : ' none'})
					)
			.css({'width': '100%', 'height' : "450px"})
			.resizable({
			  resize: function( event, ui ) {
				  $jQ( this ).find( "textarea" )
				  .css({ 'width' : (ui.element.width() - 10 ) + 'px' , 'height' : (ui.element.height() - 40 ) + 'px' });
			  }
			});
	}
	
	var textareaVal = $container.find( "textarea" ).val();
	var appendedVal = "uploaded " + data.id + " \t " + data.title + "\n";
	
	$container.find( "textarea" ).val( textareaVal + appendedVal );
	
}