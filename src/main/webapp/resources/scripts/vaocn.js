var snorqlDialog;

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
					.addClass("sparql-iframe")
			);
			/* open dialog box */
			var dialogOptions = getDialogOptions("Linked Data Explore", 1024, 500);
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

function getDialogOptions( dialogTitle, dialogWidth, dialogHeight, isModal, isResizeble, isDraggable){
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
	    	  $("#snorql-button").removeClass( "current" );
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