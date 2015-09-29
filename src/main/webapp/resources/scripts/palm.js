/*! PALM palm.js
 * ================
 * Main JavaScript file extended from AdminLTE v2. 
 * This file should be included in all pages. 
 * It controls some layout options and plugins.
 *
 * @Default Author  Almsaeed Studio
 * @Extended By  Sigit for PALM project
 * @license MIT <http://opensource.org/licenses/MIT>
 */

'use strict';

//Make sure jQuery has been loaded before palm.js
if (typeof jQuery === "undefined") {
  throw new Error("PALM requires jQuery");
}

/* PALM
 *
 * @type Object
 * @description $.PALM is the main object for the template's app.
 *              It's used for implementing functions and options related
 *              to the template. Keeping everything wrapped in an object
 *              prevents conflict with other plugins and is a better
 *              way to organize our code.
 */
$.PALM = {};

/* --------------------
 * - PALM Options -
 * --------------------
 * Modify these options to suit your implementation
 */
$.PALM.options = {
  //Add slimscroll to navbar menus
  //This requires you to load the slimscroll plugin
  //in every page before palm.js
  navbarMenuSlimscroll: true,
  navbarMenuSlimscrollWidth: "3px", //The width of the scroll bar
  navbarMenuHeight: "200px", //The height of the inner menu
  //Sidebar push menu toggle button selector
  sidebarToggleSelector: "[data-toggle='offcanvas']",
  //Activate sidebar push menu
  sidebarPushMenu: true,
  //Activate sidebar slimscroll if the fixed layout is set (requires SlimScroll Plugin)
  sidebarSlimScroll: false,
  //BoxRefresh Plugin
  enableBoxRefresh: true,
  //Bootstrap.js tooltip
  enableBSToppltip: true,
  BSTooltipSelector: "[data-toggle='tooltip']",
  //Enable Fast Click. Fastclick.js creates a more
  //native touch experience with touch devices. If you
  //choose to enable the plugin, make sure you load the script
  //before PALM's palm.js
  enableFastclick: true,
  //Box Widget Plugin. Enable this plugin
  //to allow boxes to be collapsed and/or removed
  enableBoxWidget: true,
  //Pop Up message Plugin. Enable this plugin
  //to allow information of progress or message shown on popup 
  enablePopUpMessage: true,
  //Box Widget plugin options
  boxWidgetOptions: {
    boxWidgetIcons: {
      //The icon that triggers the collapse event
      collapse: 'fa fa-minus',
      //The icon that trigger the opening event
      open: 'fa fa-plus',
      //The icon that triggers the removing event
      remove: 'fa fa-times'
    },
    boxWidgetSelectors: {
      //Remove button selector
      remove: '[data-widget="remove"]',
      //Collapse button selector
      collapse: '[data-widget="collapse"]',
      // Move button handler
      move: '[data-widget="move"]'
    }
  },
  popUpMessageOptions:{
	  directlyRemove:true,
  	  popUpHeight:35,
  	  showDuration:2000,
  	  popupType:'normal',
	  popUpElement:[],
	  popUpTypeClasses:{
		  loading: 'bg-aqua',
		  normal: 'bg-aqua',
		  success: 'bg-green',
		  warn: 'bg-yellow',
		  error: 'bg-red'
	  },
	  popUpIcons: {
		  loading: 'fa fa-refresh fa-spin',
		  normal: 'fa fa-refresh fa-spin',
		  success: 'fa fa-check',
		  warn: 'fa fa-exclamation-triangle',
		  error: 'fa fa-frown-o'
	  },
	  polling:false,
	  pollingUrl: "",
	  pollingTime: 2000
  },
  //Direct Chat plugin options
  directChat: {
    //Enable direct chat by default
    enable: false,
    //The button to open and close the chat contacts pane
    contactToggleSelector: '[data-widget="chat-pane-toggle"]'
  },
  //Define the set of colors to use globally around the website
  colors: {
    lightBlue: "#3c8dbc",
    red: "#f56954",
    green: "#00a65a",
    aqua: "#00c0ef",
    yellow: "#f39c12",
    blue: "#0073b7",
    navy: "#001F3F",
    teal: "#39CCCC",
    olive: "#3D9970",
    lime: "#01FF70",
    orange: "#FF851B",
    fuchsia: "#F012BE",
    purple: "#8E24AA",
    maroon: "#D81B60",
    black: "#222222",
    gray: "#d2d6de"
  },
  //The standard screen sizes that bootstrap uses.
  //If you change these in the variables.less file, change
  //them here too.
  screenSizes: {
    xs: 480,
    sm: 768,
    md: 992,
    lg: 1200
  },
  registeredWidget:[],
  // main nav menu selector
  navMenuSelector : ".navbar-custom-menu"
};

/* ------------------
 * - Implementation -
 * ------------------
 * The next block of code implements PALM's
 * functions and plugins as specified by the
 * options above.
 */
$(function () {
  //Easy access to options
  var o = $.PALM.options;

  //Activate the layout maker
  $.PALM.layout.activate();

  //Enable sidebar tree view controls
  $.PALM.tree('.sidebar');

  //Add slimscroll to navbar dropdown
  if (o.navbarMenuSlimscroll && typeof $.fn.slimscroll != 'undefined') {
    $(".navbar .menu").slimscroll({
      height: "200px",
      alwaysVisible: false,
      size: "3px"
    }).css("width", "100%");
  }

  //Activate sidebar push menu
  if (o.sidebarPushMenu) {
    $.PALM.pushMenu(o.sidebarToggleSelector);
    // for small screen
    if ($(window).width() < ($.PALM.options.screenSizes.sm - 1)) {
        $( o.sidebarToggleSelector ).click();
        $( o.navMenuSelector ).find( "strong" ).hide();
    }
  }

  //Activate Bootstrap tooltip
  if (o.enableBSToppltip) {
    $(o.BSTooltipSelector).tooltip();
  }

  //Activate box widget
  if (o.enableBoxWidget) {
    $.PALM.boxWidget.activate();
  }

  //Activate fast click
  if (o.enableFastclick && typeof FastClick != 'undefined') {
    FastClick.attach(document.body);
  }

  //Activate direct chat widget
  if (o.directChat.enable) {
    $(o.directChat.contactToggleSelector).click(function () {
      var box = $(this).parents('.direct-chat').first();
      box.toggleClass('direct-chat-contacts-open');
    });
  }

  /*
   * INITIALIZE BUTTON TOGGLE
   * ------------------------
   */
  $('.btn-group[data-toggle="btn-toggle"]').each(function () {
    var group = $(this);
    $(this).find(".btn").click(function (e) {
      group.find(".btn.active").removeClass("active");
      $(this).addClass("active");
      e.preventDefault();
    });

  });
});

/* ----------------------
 * - PALM Functions -
 * ----------------------
 * All PALM functions are implemented below.
 */

/* prepareLayout
 * =============
 * Fixes the layout height in case min-height fails.
 *
 * @type Object
 * @usage $.PALM.layout.activate()
 *        $.PALM.layout.fix()
 *        $.PALM.layout.fixSidebar()
 */
$.PALM.layout = {
  activate: function () {
	var o = $.PALM.options;
    var _this = this;
    _this.fix();
    _this.fixSidebar( o );
    $(window, ".wrapper").resize(function () {
      _this.fix();
      _this.fixSidebar( o );
    });
  },
  fix: function () {
    //Get window height and the wrapper height
    var neg = $('.main-header').outerHeight() + $('.main-footer').outerHeight();
    var window_height = $(window).height();
    var sidebar_height = $(".sidebar").height();
    //Set the min-height of the content and sidebar based on the
    //the height of the document.
    if ($("body").hasClass("fixed")) {
      $(".content-wrapper, .right-side").css('min-height', window_height - $('.main-footer').outerHeight());
    } else {
      if (window_height >= sidebar_height) {
        $(".content-wrapper, .right-side").css('min-height', window_height - neg);
      } else {
        $(".content-wrapper, .right-side").css('min-height', sidebar_height);
      }
    }
  },
  fixSidebar: function ( o ) {
    //Make sure the body tag has the .fixed class
    if (!$("body").hasClass("fixed") && o.sidebarSlimScroll ) {
      if (typeof $.fn.slimScroll != 'undefined') {
        $(".sidebar").slimScroll({destroy: true}).height("auto");
      }
      return;
    } else if (typeof $.fn.slimScroll == 'undefined' && console) {
      console.error("Error: the fixed layout requires the slimscroll plugin!");
    }
    //Enable slimscroll for fixed layout
    if ($.PALM.options.sidebarSlimScroll) {
      if (typeof $.fn.slimScroll != 'undefined') {
        //Distroy if it exists
        $(".sidebar").slimScroll({destroy: true}).height("auto");
        //Add slimscroll
        $(".sidebar").slimscroll({
          height: ($(window).height() - $(".main-header").height()) + "px",
          color: "rgba(0,0,0,0.2)",
          size: "3px"
        });
      }
    }
  }
};

/* PushMenu()
 * ==========
 * Adds the push menu functionality to the sidebar.
 *
 * @type Function
 * @usage: $.PALM.pushMenu("[data-toggle='offcanvas']")
 */
$.PALM.pushMenu = function (toggleBtn) {
  //Get the screen sizes
  var screenSizes = this.options.screenSizes;

  //Enable sidebar toggle
  $(toggleBtn).click(function (e) {
    e.preventDefault();

    //Enable sidebar push menu
    if ($(window).width() > (screenSizes.sm - 1)) {
      $("body").toggleClass('sidebar-collapse');
    }
    //Handle sidebar push menu for small screens
    else {
      if ($("body").hasClass('sidebar-open')) {
        $("body").removeClass('sidebar-open');
        $("body").removeClass('sidebar-collapse')
      } else {
        $("body").addClass('sidebar-open');
      }
    }
  });

  $(".content-wrapper").click(function () {
    //Enable hide menu when clicking on the content-wrapper on small screens
    if ($(window).width() <= (screenSizes.sm - 1) && $("body").hasClass("sidebar-open")) {
      $("body").removeClass('sidebar-open');
    }
  });

};

/* Tree()
 * ======
 * Converts the sidebar into a multilevel
 * tree view menu.
 *
 * @type Function
 * @Usage: $.PALM.tree('.sidebar')
 */
$.PALM.tree = function (menu) {
  var _this = this;

  $("li a", $(menu)).click(function (e) {
    //Get the clicked link and the next element
    var $this = $(this);
    var checkElement = $this.next();

    //Check if the next element is a menu and is visible
    if ((checkElement.is('.treeview-menu')) && (checkElement.is(':visible'))) {
      //Close the menu
      checkElement.slideUp('normal', function () {
        checkElement.removeClass('menu-open');
        //Fix the layout in case the sidebar stretches over the height of the window
        //_this.layout.fix();
      });
      checkElement.parent("li").removeClass("active");
    }
    //If the menu is not visible
    else if ((checkElement.is('.treeview-menu')) && (!checkElement.is(':visible'))) {
      //Get the parent menu
      var parent = $this.parents('ul').first();
      //Close all open menus within the parent
      var ul = parent.find('ul:visible').slideUp('normal');
      //Remove the menu-open class from the parent
      ul.removeClass('menu-open');
      //Get the parent li
      var parent_li = $this.parent("li");

      //Open the target menu and add the menu-open class
      checkElement.slideDown('normal', function () {
        //Add the class active to the parent li
        checkElement.addClass('menu-open');
        parent.find('li.active').removeClass('active');
        parent_li.addClass('active');
        //Fix the layout in case the sidebar stretches over the height of the window
        _this.layout.fix();
      });
    }
    //if this isn't a link, prevent the page from being redirected
    if (checkElement.is('.treeview-menu')) {
      e.preventDefault();
      checkElement.parent("li").addClass("active");
    }
    else{
    	e.preventDefault();
    	$this.parent("li").addClass("active");
    	// get content via ajax
    	var url = $this.attr( "href" );
    	if( url !== "#" )
    		getContentViaAjax( $this.attr( "href" ), "section.content .row");
    }
  });
};

/* BoxWidget
 * =========
 * BoxWidget is plugin to handle collapsing and
 * removing boxes from the screen.
 *
 * @type Object
 * @usage $.PALM.boxWidget.activate()
 *        Set all of your option in the main $.PALM.options object
 */
$.PALM.boxWidget = {
  activate: function () {
    var o = $.PALM.options;
    var _this = this;
    // make sortable
    _this.moveable( o.boxWidgetOptions.boxWidgetSelectors.move);
    //Listen for collapse event triggers
    $(o.boxWidgetOptions.boxWidgetSelectors.collapse).click(function (e) {
      e.preventDefault();
      _this.collapse($(this));
    });

    //Listen for remove event triggers
    $(o.boxWidgetOptions.boxWidgetSelectors.remove).click(function (e) {
      e.preventDefault();
      _this.remove($(this));
    });
  },
  activateSpecific: function ( $widgetElement ) {
    var o = $.PALM.options;
    var _this = this;
    //Listen for collapse event triggers
    $widgetElement.find(o.boxWidgetOptions.boxWidgetSelectors.collapse).click(function (e) {
      e.preventDefault();
      _this.collapse($(this));
    });

    //Listen for remove event triggers
    $widgetElement.find(o.boxWidgetOptions.boxWidgetSelectors.remove).click(function (e) {
      e.preventDefault();
      _this.remove($(this));
    });
  },
  refresh: function ( $widgetElement, options) {
	var emptyFunction = function(){};
	//  options
    var settings = $.extend({
      //File source to be loaded
      source: "",
      //Callbacks
      onRefreshStart: emptyFunction, //Right after refresh start
      onRefreshDone: emptyFunction //Right after refresh done
    }, options);
    
    // just before ajax call
    settings.onRefreshStart( $widgetElement );
    // load json ajax
    var additionalQueryString = "";
    if( typeof settings.queryString != "undefined" )
    	additionalQueryString = settings.queryString;
    $.getJSON( settings.source + additionalQueryString, function( data ){
    	settings.onRefreshDone( $widgetElement , data);
    	// remove overlay and loading 
    	$widgetElement.find( ".overlay" ).remove();
    });
    
    
  },
  moveable: function ( handleSelector ) {
	 $( "section.content .row" ).sortable({
	   connectWith: "section.content .row",
	   handle: handleSelector,
	   cursor: "move",
	   placeholder: "widget-placeholder",
	   start: function(e, ui ){
           ui.placeholder.height(ui.helper.outerHeight() - 20);
           ui.placeholder.width(ui.helper.outerWidth() - 30);
       }
	  });
  },
  collapse: function (element) {
    //Find the box parent
    var box = element.parents(".box").first();
    //Find the body and the footer
    var bf = box.find(".box-body, .box-footer");
    if (!box.hasClass("collapsed-box")) {
      //Convert minus into plus
      element.children(".fa-minus").removeClass("fa-minus").addClass("fa-plus");
      bf.slideUp(300, function () {
        box.addClass("collapsed-box");
      });
    } else {
      //Convert plus into minus
      element.children(".fa-plus").removeClass("fa-plus").addClass("fa-minus");
      bf.slideDown(300, function () {
        box.removeClass("collapsed-box");
      });
    }
  },
  remove: function (element) {
    //Find the box parent
    var box = element.parents(".box").first();
    box.slideUp();
  },
  options: $.PALM.options.boxWidgetOptions
};

/*
 * PopUp Message
 * ============
 * Plugin for handing notification, message and progress
 */
$.PALM.popUpMessage = {
	create: function( popUpMessage, popUpOptions){
		if( typeof popUpMessage === 'undefined' )
			return false;
		
		var o = $.PALM.options.popUpMessageOptions;
		var _this = this;
		
		if( typeof popUpOptions != "undefined" )
			o = $.extend( $.PALM.options.popUpMessageOptions, popUpOptions );
		
		if(  typeof uniqueId != "undefined" )
			o.uniqueId = $.PALM.utility.generateUniqueId();
		
		// calculate element top position
		var windowHeight = $( window ).height();
		var popUpTop = windowHeight - o.popUpHeight - 10;
		// update other popup element if exist
		if( o.popUpElement.length > 0 ){
			$.each( o.popUpElement, function( index, item ){
				item.top -= ( o.popUpHeight + 10 );
				$( item.element ).css({ "top" : item.top + "px"});
			});
		}
		// calculate element width
		var popUpWidth = 450;
		var windowWidth = $( window ).width();
		if( windowWidth < 450)
			popUpWidth = windowWidth - 20;
		
		// get popupType style
		var popUpClass = o.popUpTypeClasses[ o.popupType ];
		var popUpIcon = o.popUpIcons[ o.popupType ];
		
		// create new popup 
		var popUpObject = {
			id: o.uniqueId,
			status:"active",
			height: o.popUpHeight,
			top: popUpTop,
			polling: o.polling,
			element:
				$( '<div/>' )
		    	.attr({ 'data-type':'normal' })
		    	.addClass( "palm_message_popup col-lg-3 col-xs-6 " + popUpClass )
		    	.css({ "width": popUpWidth + "px" , "height": o.popUpHeight + "px" , "top": popUpTop + "px"})
		    	.append(
		    			$( '<div/>' )
		    	    	.addClass( "icon" )
		    	    	.addClass( popUpIcon )
				)
		    	.append(
		    			$( '<div/>' )
		    	    	.addClass( "inner" )
		    	    	.html( popUpMessage )
				)
				.hide()
		}
		// for polling message
		if( o.polling ){
			popUpObject.pollingObject = setInterval( function(){ _this.polling( o.uniqueId, o.pollingUrl , _this); }, o.pollingTime);
		}
		
		// put element into body
		$( "body" ).append( popUpObject.element );
		
		// put into PALM object
		o.popUpElement.push( popUpObject );
	    
		// display element with animation
		$( popUpObject.element ).fadeIn( "fast" );
		 
    	if( o.directlyRemove ){
    		// when animation done
    		$( popUpObject.element ).promise().done(function(){
    		    // remove object after duration end
    			setTimeout(
				  function() 
				  {
					  _this.remove( o.uniqueId );
				  }, o.showDuration);
    			
    		});
    		
    	}else{
    		// return object id
    		$( popUpObject.element ).delay( 1500 );
    		return o.uniqueId;
    	}
		
	},
	polling: function( objectId , pollingUrl , _this){
		$.get( pollingUrl , function( data ) {
			_this.update( objectId, data , _this);
		});
	},
	update: function( objectId , newPopUpMessage, _this){
		var targetObject = _this.getPopUpObject( objectId );
		$( targetObject.element ).find( ".inner" ).html( newPopUpMessage );
	},
	remove: function( objectId ){
		// get the object and remove from document
		var targetElement = $.PALM.popUpMessage.getPopUpObject( objectId );
		
		// not found return false
		if( targetElement == null )
			return false;
		
		// update with fading efect
		$( targetElement.element ).fadeOut( "fast" );
		
		// if target element is polling, stop polling
		if( targetElement.polling )
			clearInterval( targetElement.pollingObject );
		
		// remove from list
		$( targetElement.element ).promise().done(function(){
			$( targetElement.element ).remove();
			$.grep( $.PALM.options.popUpMessageOptions.popUpElement, function( e ){
				if( e.id === objectId ) // remove when object id match
					return false;
				return true;
			});
		});
	},
	getPopUpObject: function ( objectId ){
		// get the object and remove from document
		var targetElement = null;
		$.each( $.PALM.options.popUpMessageOptions.popUpElement, function( index, item ){
			if( item.id === objectId ){
				targetElement = item;
			}
		});
		
		return targetElement;
	}
};

$.PALM.utility = {
	generateUniqueId: function(){
		var aplhaNumeric = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		var randomAlphanumeric = "";
		for (var i = 10; i > 0; --i) 
			randomAlphanumeric += aplhaNumeric[Math.round(Math.random() * (aplhaNumeric.length - 1))];
		return randomAlphanumeric;
	}
};
 
$.PALM.postForm = {
	viaAjax:function( $form, resultContainerSelector ){
		
	},
	viaAjaxAndReload: function( $form , message ){
		// pop up message
		var popUpId = $.PALM.popUpMessage.create( message, {popupType:"loading", directlyRemove:false} );
		// sent form content via ajax POST
		$.post( $form.attr( "action" ), $form.serialize() )
			.done( function ( jsonData ){
				if( jsonData.format == "json" ){
					if( jsonData.status == "ok" ){
						$.PALM.popUpMessage.remove( popUpId );
						
						var targetElement = $.PALM.popUpMessage.getPopUpObject( popUpId );
						// reload page afteranimation complete
						$( targetElement ).promise().done(function(){
							window.location.reload( false );
						});
					} else 
						$.PALM.popUpMessage.create( "Sorry, saving process failed please try again", {popupType:"error"} );
				} else{
					$.PALM.popUpMessage.create( "Sorry, saving process failed please try again", {popupType:"error"} );
				}
			})
			.fail( function(xhr, textStatus, errorThrown ) {
				$.PALM.popUpMessage.remove( popUpId );
				$.PALM.popUpMessage.create( "Sorry, saving process failed please try again", {popupType:"error"} );
			});
	}
};

/* ------------------
 * - Custom Plugins -
 * ------------------
 * All custom plugins are defined below.
 */

/*
 * BOX REFRESH BUTTON
 * ------------------
 * This is a custom plugin to use with the compenet BOX. It allows you to add
 * a refresh button to the box. It converts the box's state to a loading state.
 *
 * @type plugin
 * @usage $("#box-widget").boxRefresh( options );
 */
(function ($) {

  $.fn.boxRefresh = function (options) {

    // Render options
    var settings = $.extend({
      //Refressh button selector
      trigger: ".refresh-btn",
      //File source to be loaded (e.g: ajax/src.php)
      source: "",
      //Callbacks
      onLoadStart: function (box) {
      }, //Right after the button has been clicked
      onLoadDone: function (box) {
      } //When the source has been loaded

    }, options);

    //The overlay
    var overlay = $('<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>');

    return this.each(function () {
      //if a source is specified
      if (settings.source === "") {
        if (console) {
          console.log("Please specify a source first - boxRefresh()");
        }
        return;
      }
      //the box
      var box = $(this);
      //the button
      var rBtn = box.find(settings.trigger).first();

      //On trigger click
      rBtn.click(function (e) {
        e.preventDefault();
        //Add loading overlay
        start(box);

        //Perform ajax call
        box.find(".box-body").load(settings.source, function () {
          done(box);
        });
      });
    });

    function start(box) {
      //Add overlay and loading img
      box.append(overlay);

      settings.onLoadStart.call(box);
    }

    function done(box) {
      //Remove overlay and loading img
      box.find(overlay).remove();

      settings.onLoadDone.call(box);
    }

  };

})(jQuery);

/*
 * TODO LIST CUSTOM PLUGIN
 * -----------------------
 * This plugin depends on iCheck plugin for checkbox and radio inputs
 *
 * @type plugin
 * @usage $("#todo-widget").todolist( options );
 */
(function ($) {

  $.fn.todolist = function (options) {
    // Render options
    var settings = $.extend({
      //When the user checks the input
      onCheck: function (ele) {
      },
      //When the user unchecks the input
      onUncheck: function (ele) {
      }
    }, options);

    return this.each(function () {

      if (typeof $.fn.iCheck != 'undefined') {
        $('input', this).on('ifChecked', function (event) {
          var ele = $(this).parents("li").first();
          ele.toggleClass("done");
          settings.onCheck.call(ele);
        });

        $('input', this).on('ifUnchecked', function (event) {
          var ele = $(this).parents("li").first();
          ele.toggleClass("done");
          settings.onUncheck.call(ele);
        });
      } else {
        $('input', this).on('change', function (event) {
          var ele = $(this).parents("li").first();
          ele.toggleClass("done");
          settings.onCheck.call(ele);
        });
      }
    });
  };
}(jQuery));



/**
 * GET content via ajax as html
 */
function getContentViaAjax( url, containerSelector, alwaysCallback){
	var jqxhr = $.get( url, function( html ) {
		$( containerSelector ).html( html );
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



function postFormViaAjax( $form, resultContainerSelector ){
	// TODO input check
	
	// sent form content via ajax POST
	$.post( $form.attr( "action" ), $form.serialize(), function ( jsonData ){
		if( jsonData.format == "json" ){
			console.log( jsonData.result );
		} else if( jsonData.format == "javascript" ){
			
		}
		else{// html
			
		}
	});
	
	return false;
}

function postFormAndReloadPageViaAjax( $form , message){
	
	// sent form content via ajax POST
	$.post( $form.attr( "action" ), $form.serialize(), function ( jsonData ){
		if( jsonData.format == "json" ){
			console.log( jsonData.result );
		} else if( jsonData.format == "javascript" ){
			
		}
		else{// html
			
		}
	});
	
	return false;
}












/* global variables */

/* document ready */
$(function(){
	$( "#signin_button" ).click( function( event ){
		event.preventDefault();
		// get login form
		getFormViaAjax( "login?form=true" );
	});
	
});

/**
 * get form via ajax
 */
function getFormViaAjax( url , alwaysCallback){
	var jqxhr = $.get( baseUrl + "/" +  url, function( html ) {
		// removing query string
		var formType = url.split( "?" );
		getPopUpForm( formType[0], html );
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
	var $popUpElem = 
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
/*
function getContentViaAjax( url, containerSelector ){
	$( containerSelector ).addClass( "ajax-loading-image" );
	var jqxhr = $.ajax( url )
	  .done(function( html ) {
	    $( containerSelector ).html( html );
	  })
	  .fail(function() {
	  })
	  .always(function() {
		  $( containerSelector ).removeClass( "ajax-loading-image" );
	  });
}*/

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