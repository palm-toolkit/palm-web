/*! PALM palm.js
 * ================
 * Main JavaScript file extended from AdminLTE v2. 
 * This file should be included in all pages. 
 * It controls some layout options and plugins.
 *
 * @Original Author  Almsaeed Studio
 * @Extended By  Anindita Sigit Nugraha for PALM project
 * @license MIT <http://opensource.org/licenses/MIT>
 */

'use strict';

// Make sure jQuery has been loaded before palm.js
if (typeof jQuery === "undefined") {
	throw new Error("PALM requires jQuery");
}

/*
 * PALM
 * 
 * @type Object @description $.PALM is the main object for the template's app.
 * It's used for implementing functions and options related to the template.
 * Keeping everything wrapped in an object prevents conflict with other plugins
 * and is a better way to organize our code.
 */
$.PALM = {};

/*
 * -------------------- - PALM Options - -------------------- Modify these
 * options to suit your implementation
 */
$.PALM.options = {
	// Add slimscroll to navbar menus
	// This requires you to load the slimscroll plugin
	// in every page before palm.js
	navbarMenuSlimscroll : true,
	navbarMenuSlimscrollWidth : "3px", // The width of the scroll bar
	navbarMenuHeight : "200px", // The height of the inner menu
	// Sidebar push menu toggle button selector
	sidebarToggleSelector : "[data-toggle='offcanvas']",
	// Activate sidebar push menu
	sidebarPushMenu : true,
	// Activate sidebar slimscroll if the fixed layout is set (requires
	// SlimScroll Plugin)
	sidebarSlimScroll : false,
	// BoxRefresh Plugin
	enableBoxRefresh : true,
	// Bootstrap.js tooltip
	enableBSToppltip : true,
	BSTooltipSelector : "[data-toggle='tooltip']",
	// Enable Fast Click. Fastclick.js creates a more
	// native touch experience with touch devices. If you
	// choose to enable the plugin, make sure you load the script
	// before PALM's palm.js
	enableFastclick : true,
	// Box Widget Plugin. Enable this plugin
	// to allow boxes to be collapsed and/or removed
	enableBoxWidget : true,
	// Pop Up message Plugin. Enable this plugin
	// to allow information of progress or message shown on popup
	enablePopUpMessage : true,
	// Box Widget plugin options
	boxWidgetOptions : {
		boxWidgetIcons : {
			// The icon that triggers the collapse event
			collapse : 'fa fa-minus',
			// The icon that trigger the opening event
			open : 'fa fa-plus',
			// The icon that triggers the removing event
			remove : 'fa fa-times'
		},
		boxWidgetSelectors : {
			// Remove button selector
			remove : '[data-widget="remove"]',
			// Collapse button selector
			collapse : '[data-widget="collapse"]',
			// Move button handler
			move : '[data-widget="move"]'
		}
	},
	popUpMessageOptions : {
		directlyRemove : true,
		popUpHeight : 35,
		showDuration : 2000,
		popupType : 'normal',
		popUpElement : [],
		popUpTypeClasses : {
			loading : 'bg-aqua',
			normal : 'bg-aqua',
			success : 'bg-green',
			warn : 'bg-yellow',
			error : 'bg-red'
		},
		popUpIcons : {
			loading : 'fa fa-refresh fa-spin',
			normal : 'fa fa-refresh fa-spin',
			success : 'fa fa-check',
			warn : 'fa fa-exclamation-triangle',
			error : 'fa fa-frown-o'
		},
		polling : false,
		pollingUrl : "",
		pollingTime : 2000
	},
	popUpIframeOptions : {
		popUpWidth : "60%",
		popUpHeight : "80%",
		popUpMargin : "4% auto",
		popUpMaxWidth : "1000px",
		popUpCloseSelector : "dialog-close",
		popUpIframeClasses : {
			modalContainer : "dialog-modal-container",
			modalOverlay : "dialog-overlay",
			dialogContainer : "dialog-container",
			dialogHeader : "dialog-header",
			dialogContent : "dialog-content",
			dialogCloseContainer : "dialog-close-container",
			dialogCloseButton : "dialog-close-button fa fa-times"
		},
		popUpIframe : []
	},
	// Direct Chat plugin options
	directChat : {
		// Enable direct chat by default
		enable : false,
		// The button to open and close the chat contacts pane
		contactToggleSelector : '[data-widget="chat-pane-toggle"]'
	},
	// Define the set of colors to use globally around the website
	colors : {
		lightBlue : "#3c8dbc",
		red : "#f56954",
		green : "#00a65a",
		aqua : "#00c0ef",
		yellow : "#f39c12",
		blue : "#0073b7",
		navy : "#001F3F",
		teal : "#39CCCC",
		olive : "#3D9970",
		lime : "#01FF70",
		orange : "#FF851B",
		fuchsia : "#F012BE",
		purple : "#8E24AA",
		maroon : "#D81B60",
		black : "#222222",
		gray : "#d2d6de"
	},
	// The standard screen sizes that bootstrap uses.
	// If you change these in the variables.less file, change
	// them here too.
	screenSizes : {
		xs : 480,
		sm : 768,
		md : 970,
		lg : 1200
	},
	registeredWidget : [],
	xhrPool : [],
	// main nav menu selector
	navMenuSelector : ".navbar-custom-menu"
};

/*
 * ------------------ - Implementation - ------------------ The next block of
 * code implements PALM's functions and plugins as specified by the options
 * above.
 */
$(function() {
	// Easy access to options
	var o = $.PALM.options;

	// Activate the layout maker
	$.PALM.layout.activate();

	// Enable sidebar tree view controls
	$.PALM.tree('.sidebar');

	// Add slimscroll to navbar dropdown
	if (o.navbarMenuSlimscroll && typeof $.fn.slimscroll != 'undefined') {
		$(".navbar .menu").slimscroll({
			height : "200px",
			alwaysVisible : false,
			size : "3px"
		}).css("width", "100%");
	}

	// Activate sidebar push menu
	if (o.sidebarPushMenu) {
		$.PALM.pushMenu(o.sidebarToggleSelector);
		// for small screen
		if ($(window).width() <= $.PALM.options.screenSizes.md) {
			$(o.sidebarToggleSelector).click();
			// add bootstrap tooltip
			$.each($(o.navMenuSelector).find("a"), function(index, elem) {
				$(elem).find("strong").hide();
				if (typeof $(elem).attr("title") != "undefined")
					$(elem).attr({
						"data-toggle" : "tooltip",
						"data-placement" : "bottom",
						"data-original-title" : $(elem).attr("title")
					});
			});
		}

	}

	// Activate Bootstrap tooltip
	if (o.enableBSToppltip) {
		$(o.BSTooltipSelector).tooltip();
	}

	// Activate box widget
	if (o.enableBoxWidget) {
		$.PALM.boxWidget.activate();
	}

	// Activate fast click
	if (o.enableFastclick && typeof FastClick != 'undefined') {
		FastClick.attach(document.body);
	}

	// Activate direct chat widget
	if (o.directChat.enable) {
		$(o.directChat.contactToggleSelector).click(function() {
			var box = $(this).parents('.direct-chat').first();
			box.toggleClass('direct-chat-contacts-open');
		});
	}

	/*
	 * INITIALIZE BUTTON TOGGLE ------------------------
	 */
	$('.btn-group[data-toggle="btn-toggle"]').each(function() {
		var group = $(this);
		$(this).find(".btn").click(function(e) {
			group.find(".btn.active").removeClass("active");
			$(this).addClass("active");
			e.preventDefault();
		});

	});
});

/*
 * ---------------------- - PALM Functions - ---------------------- All PALM
 * functions are implemented below.
 */

/*
 * Global object, pointer to selected item
 */
$.PALM.selected = {
	record : function(typeSelected, selectedObject, activeObjects) {
		var _this = this;
		// check whether object already selected
		if (!_this.isSimilarWithCurrentObject(typeSelected, selectedObject,
				activeObjects)) {
			_this.reset();
			if (typeSelected == "researcher") {
				_this.researcher = selectedObject;
			} else if (typeSelected == "publication") {
				_this.publication = selectedObject;
			} else if (typeSelected == "event") {
				_this.event = selectedObject;
			} else if (typeSelected == "eventGroup") {
				_this.eventGroup = selectedObject;
			} else if (typeSelected == "circle") {
				_this.circle = selectedObject;
			}
			if (typeof activeObjects !== "undefined"
					&& activeObjects.length > 0) {
				$.each(activeObjects, function(index, item) {
					$(item).removeClass("text-gray");
					$(item).addClass("active");
				});
			}
			// record active objects
			_this.activeObjects = activeObjects;
			return true;
		} else
			return false;
	},
	isSimilarWithCurrentObject : function(typeSelected, selectedObject,
			activeObjects) {
		var _this = this;
		if (typeSelected == "researcher"
				&& typeof _this.researcher != "undefined"
				&& _this.researcher == selectedObject) {
			return true;
		} else if (typeSelected == "publication"
				&& typeof _this.publication != "undefined"
				&& _this.publication == selectedObject) {
			return true;
		} else if (typeSelected == "event" && typeof _this.event != "undefined"
				&& _this.event == selectedObject) {
			return true;
		} else if (typeSelected == "eventGroup"
				&& typeof _this.eventGroup != "undefined"
				&& _this.eventGroup == selectedObject) {
			if (typeof activeObjects.next() !== "undefined") {
				if (activeObjects.next().is(":visible"))
					activeObjects.next().hide();
				else
					activeObjects.next().show();
			}
			return true;
		} else if (typeSelected == "circle"
				&& typeof _this.circle != "undefined"
				&& _this.circle == selectedObject) {
			return true;
		}
		// show fetched event group
		if (typeSelected == "eventGroup")
			activeObjects.next().show();
		// remove and abort any ajax request
		$.each($.PALM.options.xhrPool, function(index, jqXHR) {
			jqXHR.abort();
		});
		// reset ajax pool
		$.PALM.options.xhrPool = [];
		// remove any popup message
		$.each($.PALM.options.popUpMessageOptions.popUpElement, function(index,
				item) {
			item.element.remove();
		});
		// reset popup messages
		$.PALM.options.popUpMessageOptions.popUpElement = [];
		return false;
	},
	reset : function() {
		var _this = this;
		if (typeof _this.activeObjects !== "undefined"
				&& _this.activeObjects.length > 0) {
			$.each(_this.activeObjects, function(index, item) {
				$(item).removeClass("active");
			});
			// make array empty
			_this.activeObjects = [];
		}
	}
};

/*
 * PALM circle ============= This relevant to circle object
 * 
 * Variables: _this = $.PALM.circle
 *  // contain current researcher / publication list from AJAX paging
 * _this.currentResearcherData _this.currentPublicationData
 *  // contain clean (minus researcher/publication already on circle) current //
 * researcher / publication list from AJAX paging
 * _this.currentCleanResearcherData _this.currentCleanPublicationData
 *  // contain list of researcher / publication objects on circle
 * _this.reseacherOnCircle
 * 
 * 
 */
$.PALM.circle = {
	circleResearcher : [],
	circlePublication : [],
	currentCleanResearcherData : [],
	currentCleanPublicationData : [],
	/**
	 * state where the circle is loaded either new or edit
	 */
	load : function(loadType, circleId) {

	},
	/**
	 * Every time data is loaded via AJAX, replace current data check whether
	 * researcher objects already on circle
	 */
	setCurrentResearcherData : function(currentResearcherData) {
		var _this = this;
		// put researcher data into PALM variable
		_this.currentResearcherData = currentResearcherData;

		// clean / check with researcher on publication
		_this.cleanCurrentResearcherData();
	},
	/**
	 * Check if researcher already on circle fill currentCleanResearcherData
	 * with currentResearcherData not on circle
	 */
	cleanCurrentResearcherData : function() {
		var _this = this;
		// reset
		_this.currentCleanResearcherData = [];
		// check for availability
		if (_this.circleResearcher.length > 0
				&& _this.currentResearcherData.length > 0) {
			// check for duplication between current and circle
			$.each(_this.currentResearcherData, function(indexResearcher, itemResearcher) {
				var isExistOnCircle = false;
				$.each(_this.circleResearcher, function(indexCircle, itemCircle) {
					if (itemCircle.id == itemResearcher.id) {
						isExistOnCircle = true;
						return;
					}
				});

				if (!isExistOnCircle)
					_this.currentCleanResearcherData.push(itemResearcher);
			});

		} else {
			_this.currentCleanResearcherData = _this.currentResearcherData;
		}
	},
	getCleanResearcherData : function() {
		return this.currentCleanResearcherData;
	},

	/**
	 * Every time data is loaded via AJAX, replace current data check whether
	 * publication objects already on circle
	 */
	setCurrentPublicationData : function(currentPublicationData) {
		var _this = this;
		// put researcher data into PALM variable
		_this.currentPublicationData = currentPublicationData;

		// clean / check with researcher on publication
		_this.cleanCurrentPublicationData();
	},
	cleanCurrentPublicationData : function() {
		var _this = this;
		// reset
		_this.currentCleanPublicationData = [];
		// check for availability
		if (_this.circlePublication.length > 0
				&& _this.currentPublicationData.length > 0) {
			// check for duplication between current and circle
			$.each(_this.currentPublicationData, function(indexPublication, itemPublication) {
				var isExistOnCircle = false;
				$.each(_this.circlePublication, function(indexCircle, itemCircle) {
					if (itemCircle.id == itemPublication.id) {
						isExistOnCircle = true;
						return;
					}
				});

				if (!isExistOnCircle)
					_this.currentCleanPublicationData.push(itemPublication);
			});

		} else {
			_this.currentCleanPublicationData = _this.currentPublicationData;
		}
	},
	getCleanPublicationData : function() {
		return this.currentCleanPublicationData;
	},

	addResearcher : function(researcherId, triggerElement) {
		var _this = this;
		// get researcher div
		var researcherElement = $(triggerElement).parent().parent().parent();
		// assumes that input is already clean (no publication/researcher on
		// circle duplicated on input)
		$.each(_this.currentCleanResearcherData, function(index, item) {
			if (item.id == researcherId) {
				_this.circleResearcher.push(item);
				_this.currentCleanResearcherData.splice(index, 1);
				return false;
			}
		});

		// change button for remove researcher div
		$(triggerElement).html("- remove from circle").removeClass(
				"btn-success").addClass("btn-danger")
		// clear old events bind to element
		.unbind()
		// bind new event
		.on("click", function() {
			// remove researcher div
			researcherElement.remove();
			// update circle object
			_this.removeResearcher(researcherId);
		});

		researcherElement.appendTo(_this.researcherCircleList);
	},
	removeResearcher : function(researcherId) {
		var _this = this;
		$.each(_this.circleResearcher, function(index, item) {
			if (item.id == researcherId) {
				_this.currentCleanResearcherData.push(item);
				_this.circleResearcher.splice(index, 1);
				return false;
			}
		});
	},

	addPublication : function(publicationId, triggerElement) {
		var _this = this;
		// get publication div
		var publicationElement = $(triggerElement).parent().parent().parent();

		// assumes that input is already clean (no publication/researcher on
		// circle duplicated on input)
		$.each(_this.currentCleanPublicationData, function(index, item) {
			if (item.id == publicationId) {
				_this.circlePublication.push(item);
				_this.currentCleanPublicationData.splice(index, 1);
				return false;
			}
		});

		$(triggerElement).html("- remove from circle").removeClass(
				"btn-success").addClass("btn-danger")
		// clear old events bind to element
		.unbind()
		// bind new event
		.on("click", function() {
			// remove researcher div

			publicationElement.remove();
			// update circle object
			_this.removePublication(publicationId);
		});

		publicationElement.appendTo(_this.publicationCircleList);
	},
	removePublication : function(publicationId) {
		var _this = this;
		$.each(_this.circlePublication, function(index, item) {
			if (item.id == publicationId) {
				_this.currentCleanPublicationData.push(item);
				_this.circlePublication.splice(index, 1);
				return false;
			}
		});
	},

	setResearchersCircle : function(researchersCircleData) {

	},
	getResearchersCircle : function() {
		return this.circleResearcher;
	},

	setPublicationCircle : function(researchersCircleData) {

	},
	getPublicationCircle : function() {
		return this.circlePublication;
	}

}

/*
 * prepareLayout ============= Fixes the layout height in case min-height fails.
 * 
 * @type Object @usage $.PALM.layout.activate() $.PALM.layout.fix()
 * $.PALM.layout.fixSidebar()
 */
$.PALM.layout = {
	activate : function() {
		var o = $.PALM.options;
		var _this = this;
		_this.fix();
		_this.fixSidebar(o);
		$(window, ".wrapper").resize(function() {
			_this.fix();
			_this.fixSidebar(o);
		});
		_this.fixContentScroll();
		// for the window resize
		$(window).resize(
				function() {
					var bodyheight = $(window).height();
					var listHeightOffset = 192;
					if ($(window).width() < $.PALM.options.screenSizes.sm)
						listHeightOffset += 50;
					$(".content-list:first").height(bodyheight - listHeightOffset);
					$("#left-menu-sidebar").parent().height(
							bodyheight - listHeightOffset + 150);

				});
	},
	fix : function() {
		// Get window height and the wrapper height
		var neg = $('.main-header').outerHeight()
				+ $('.main-footer').outerHeight();
		var window_height = $(window).height();
		var sidebar_height = $(".sidebar").height();
		// Set the min-height of the content and sidebar based on the
		// the height of the document.
		if ($("body").hasClass("fixed")) {
			// $(".content-wrapper, .right-side").css('min-height',
			// window_height - $('.main-footer').outerHeight());
		} else {
			if (window_height >= sidebar_height) {
				// $(".content-wrapper, .right-side").css('min-height',
				// window_height - neg);
			} else {
				// $(".content-wrapper, .right-side").css('min-height',
				// sidebar_height);
			}
		}
	},
	fixSidebar : function(o) {
		// Make sure the body tag has the .fixed class
		if (!$("body").hasClass("fixed") && o.sidebarSlimScroll) {
			if (typeof $.fn.slimScroll != 'undefined') {
				$(".sidebar").slimScroll({
					destroy : true
				}).height("auto");
			}
			return;
		} else if (typeof $.fn.slimScroll == 'undefined' && console) {
			console
					.error("Error: the fixed layout requires the slimscroll plugin!");
		}
		// Enable slimscroll for fixed layout
		if ($.PALM.options.sidebarSlimScroll) {
			if (typeof $.fn.slimScroll != 'undefined') {
				// Distroy if it exists
				$(".sidebar").slimScroll({
					destroy : true
				}).height("auto");
				// Add slimscroll
				$(".sidebar").slimscroll(
						{
							height : ($(window).height() - $(".main-header")
									.height())
									+ "px",
							color : "rgba(0,0,0,0.2)",
							size : "3px"
						});
			}
		}
	},
	fixContentScroll : function() {
		var bodyheight = $(window).height();
		var listHeightOffset = 192;
		if ($(window).width() < $.PALM.options.screenSizes.sm)
			listHeightOffset += 50;
		$(".content-list:first").height(bodyheight - listHeightOffset);
		$(".content-wrapper").height(bodyheight - 50);
		$("#left-menu-sidebar").parent().height(
				bodyheight - listHeightOffset + 150);
	}

};

/*
 * PushMenu() ========== Adds the push menu functionality to the sidebar.
 * 
 * @type Function @usage: $.PALM.pushMenu("[data-toggle='offcanvas']")
 */
$.PALM.pushMenu = function(toggleBtn) {
	// Get the screen sizes
	var screenSizes = this.options.screenSizes;

	// Enable sidebar toggle
	$(toggleBtn).click(function(e) {
		e.preventDefault();

		// Enable sidebar push menu
		if ($(window).width() > screenSizes.md) {
			$("body").toggleClass('sidebar-collapse');
		}
		// Handle sidebar push menu for small screens
		else {
			if ($("body").hasClass('sidebar-open')) {
				$("body").removeClass('sidebar-open');
				$("body").removeClass('sidebar-collapse')
			} else {
				$("body").addClass('sidebar-open');
			}
		}
	});

	$(".content-wrapper").click(
			function() {
				// Enable hide menu when clicking on the content-wrapper on
				// small screens
				if ($(window).width() <= screenSizes.md
						&& $("body").hasClass("sidebar-open")) {
					$("body").removeClass('sidebar-open');
				}
			});

};

/*
 * Tree() ====== Converts the sidebar into a multilevel tree view menu.
 * 
 * @type Function @Usage: $.PALM.tree('.sidebar')
 */
$.PALM.tree = function(menu) {
	var _this = this;

	$("li a", $(menu)).click(
			function(e) {
				// Get the clicked link and the next element
				var $this = $(this);
				var checkElement = $this.next();

				// Check if the next element is a menu and is visible
				if ((checkElement.is('.treeview-menu'))
						&& (checkElement.is(':visible'))) {
					// Close the menu
					checkElement.slideUp('normal', function() {
						checkElement.removeClass('menu-open');
						// Fix the layout in case the sidebar stretches over the
						// height of the window
						// _this.layout.fix();
					});
					checkElement.parent("li").removeClass("active");
				}
				// If the menu is not visible
				else if ((checkElement.is('.treeview-menu'))
						&& (!checkElement.is(':visible'))) {
					// Get the parent menu
					var parent = $this.parents('ul').first();
					// Close all open menus within the parent
					var ul = parent.find('ul:visible').slideUp('normal');
					// Remove the menu-open class from the parent
					ul.removeClass('menu-open');
					// Get the parent li
					var parent_li = $this.parent("li");

					// Open the target menu and add the menu-open class
					checkElement.slideDown('normal', function() {
						// Add the class active to the parent li
						checkElement.addClass('menu-open');
						parent.find('li.active').removeClass('active');
						parent_li.addClass('active');
						// Fix the layout in case the sidebar stretches over the
						// height of the window
						_this.layout.fix();
					});
				}
				// if this isn't a link, prevent the page from being redirected
				if (checkElement.is('.treeview-menu')) {
					e.preventDefault();
					checkElement.parent("li").addClass("active");
				} else {
					e.preventDefault();
					$this.parent("li").siblings().removeClass("active");
					$this.parent("li").addClass("active");
					// modify address
					var dataLink = $this.parent("li").data( "link" );
					if( !$this.parent("li").hasClass( "treeview" ) )
						dataLink = $this.parent("li").parent("ul").parent("li").data( "link" ) + "-" + dataLink;
					history.pushState( null, dataLink , $.PALM.utility.removeURLParameter(window.location.href, "page") + "page=" + dataLink);
					// get content via ajax
					var url = $this.attr("href");
					if (url !== "#")
						getContentViaAjax($this.attr("href"),
								"section.content .row");
				}
			});
};

/*
 * BoxWidget ========= BoxWidget is plugin to handle collapsing and removing
 * boxes from the screen.
 * 
 * @type Object @usage $.PALM.boxWidget.activate() Set all of your option in the
 * main $.PALM.options object
 */
$.PALM.boxWidget = {
	activate : function() {
		var o = $.PALM.options;
		var _this = this;
		// make sortable
		_this.moveable(o.boxWidgetOptions.boxWidgetSelectors.move);
		// Listen for collapse event triggers
		$(o.boxWidgetOptions.boxWidgetSelectors.collapse).click(function(e) {
			e.preventDefault();
			_this.collapse($(this));
		});

		// Listen for remove event triggers
		$(o.boxWidgetOptions.boxWidgetSelectors.remove).click(function(e) {
			e.preventDefault();
			_this.remove($(this));
		});
	},
	activateSpecific : function($widgetElement) {
		var o = $.PALM.options;
		var _this = this;
		// Listen for collapse event triggers
		$widgetElement.find(o.boxWidgetOptions.boxWidgetSelectors.collapse)
				.click(function(e) {
					e.preventDefault();
					_this.collapse($(this));
				});

		// Listen for remove event triggers
		$widgetElement.find(o.boxWidgetOptions.boxWidgetSelectors.remove)
				.click(function(e) {
					e.preventDefault();
					_this.remove($(this));
				});
	},
	refresh : function($widgetElement, options) {
		var emptyFunction = function() {
		};
		// options
		var settings = $.extend({
			// File source to be loaded
			source : "",
			// Callbacks
			onRefreshStart : emptyFunction, // Right after refresh start
			onRefreshDone : emptyFunction
		// Right after refresh done
		}, options);

		// just before ajax call
		settings.onRefreshStart($widgetElement);
		// load json ajax
		var additionalQueryString = "";
		if (typeof settings.queryString != "undefined")
			additionalQueryString = settings.queryString;

		// store ajax requerst into palm object
		var jqXHR = $.getJSON(settings.source + additionalQueryString,
				function(data) {
					settings.onRefreshDone($widgetElement, data);
					// remove overlay and loading
					$widgetElement.find(".overlay").remove();
				});
		// push into ajaxPool
		$.PALM.options.xhrPool.push(jqXHR);

	},
	moveable : function(handleSelector) {
		// $.PALM.gridster = $("section.content>.row").gridster({
		// widget_base_dimensions: [200, 200],
		// widget_margins: [5, 5],
		// draggable: {
		// handle: handleSelector
		// }
		// }).data('gridster');

		$.PALM.boxWidget.sortable = $("section.content .row").sortable({
			connectWith : "section.content .row",
			handle : handleSelector,
			cursor : "move",
			placeholder : "widget-placeholder",
			start : function(e, ui) {
				ui.placeholder.height(ui.helper.outerHeight() - 20);
				ui.placeholder.width(ui.helper.outerWidth() - 30);
			}
		});

	},
	collapse : function(element) {
		// Find the box parent
		var box = element.parents(".box").first();
		// Find the body and the footer
		var bf = box.find(".box-body, .box-footer");
		if (!box.hasClass("collapsed-box")) {
			// Convert minus into plus
			element.children(".fa-minus").removeClass("fa-minus").addClass(
					"fa-plus");
			bf.slideUp(300, function() {
				box.addClass("collapsed-box");
			});
		} else {
			// Convert plus into minus
			element.children(".fa-plus").removeClass("fa-plus").addClass(
					"fa-minus");
			bf.slideDown(300, function() {
				box.removeClass("collapsed-box");
			});
		}
	},
	remove : function(element) {
		// Find the box parent
		var box = element.parents(".box").first();
		box.slideUp();
	},
	options : $.PALM.options.boxWidgetOptions,
	getByUniqueName : function(uniqueName) {
		var targetWidget;
		$.each($.PALM.options.registeredWidget, function(index, obj) {
			if (obj.selector === "#widget-" + uniqueName)
				targetWidget = obj;
		});
		return targetWidget;
	},
	removeRegisteredWidget : function(uniqueName) {
		var widgetIndex;
		$.each($.PALM.options.registeredWidget, function(index, obj) {
			if (obj.selector === "#widget-" + uniqueName)
				widgetIndex = index;
		});
		// remove
		if (widgetIndex > -1)
			$.PALM.options.registeredWidget.splice(widgetIndex, 1);
	}
};

/*
 * PopUp Message ============ Plugin for handing notification, message and
 * progress
 */
$.PALM.popUpMessage = {
	create : function(popUpMessage, popUpOptions) {
		if (typeof popUpMessage === 'undefined')
			return false;

		var o = $.PALM.options.popUpMessageOptions;
		var _this = this;

		if (typeof popUpOptions != "undefined")
			o = $.extend($.PALM.options.popUpMessageOptions, popUpOptions);

		if (typeof uniqueId != "undefined")
			o.uniqueId = $.PALM.utility.generateUniqueId();

		// calculate element top position
		var windowHeight = $(window).height();
		var popUpTop = windowHeight - o.popUpHeight - 10;
		// update other popup element if exist
		if (o.popUpElement.length > 0) {
			$.each(o.popUpElement, function(index, item) {
				item.top -= (o.popUpHeight + 10);
				$(item.element).css({
					"top" : item.top + "px"
				});
			});
		}
		// calculate element width
		var popUpWidth = 450;
		var windowWidth = $(window).width();
		if (windowWidth < 450)
			popUpWidth = windowWidth - 20;

		// get popupType style
		var popUpClass = o.popUpTypeClasses[o.popupType];
		var popUpIcon = o.popUpIcons[o.popupType];

		// create new popup
		var popUpObject = {
			id : o.uniqueId,
			status : "active",
			height : o.popUpHeight,
			top : popUpTop,
			polling : o.polling,
			element : $('<div/>').attr({
				'data-type' : 'normal'
			}).addClass("palm_message_popup col-lg-3 col-xs-6 " + popUpClass)
					.css({
						"width" : popUpWidth + "px",
						"height" : o.popUpHeight + "px",
						"top" : popUpTop + "px"
					}).append($('<div/>').addClass("icon").addClass(popUpIcon))
					.append($('<div/>').addClass("inner").html(popUpMessage))
					.hide()
		}
		// for polling message
		if (o.polling) {
			popUpObject.pollingObject = setInterval(function() {
				_this.polling(o.uniqueId, o.pollingUrl, _this);
			}, o.pollingTime);
		}

		// put element into body
		$("body").append(popUpObject.element);

		// put into PALM object
		o.popUpElement.push(popUpObject);

		// display element with animation
		$(popUpObject.element).fadeIn("fast");

		if (o.directlyRemove) {
			// when animation done
			$(popUpObject.element).promise().done(function() {
				// remove object after duration end
				setTimeout(function() {
					_this.remove(o.uniqueId);
				}, o.showDuration);

			});

		} else {
			// return object id
			$(popUpObject.element).delay(1500);
			return o.uniqueId;
		}

	},
	polling : function(objectId, pollingUrl, _this) {
		$.get(pollingUrl, function(data) {
			_this.update(objectId, data, _this);
		});
	},
	update : function(objectId, newPopUpMessage, _this) {
		var targetObject = _this.getPopUpObject(objectId);
		var logMessageContainer = $(targetObject.element).find(".inner")
		logMessageContainer.html(newPopUpMessage);
		// scroll to bottom
		logMessageContainer.scrollTop(logMessageContainer.prop("scrollHeight"));
	},
	remove : function(objectId) {
		// get the object and remove from document
		var targetElement = $.PALM.popUpMessage.getPopUpObject(objectId);

		// not found return false
		if (targetElement == null)
			return false;

		// update with fading efect
		$(targetElement.element).fadeOut("fast");

		// if target element is polling, stop polling
		if (targetElement.polling)
			clearInterval(targetElement.pollingObject);

		// remove from list
		$(targetElement.element).promise().done(
				function() {
					$(targetElement.element).remove();
					$.grep($.PALM.options.popUpMessageOptions.popUpElement,
							function(e) {
								if (e.id === objectId) // remove when object id
														// match
									return false;
								return true;
							});
				});
	},
	getPopUpObject : function(objectId) {
		// get the object and remove from document
		var targetElement = null;
		$.each($.PALM.options.popUpMessageOptions.popUpElement, function(index,
				item) {
			if (item.id === objectId) {
				targetElement = item;
			}
		});

		return targetElement;
	}
};

/**
 * PopUp Iframe ============= Plugin for handling pop up widget iframe
 */

$.PALM.popUpIframe = {
	create : function(iframeUrl, popUpOptions, iframeTitle) {
		if (typeof iframeUrl === 'undefined')
			return false;
		
		// change breowser history
		var currentUrl = window.location.href;
		var currentUrlFix = currentUrl.replace(/&add=yes/g, "");
		if ( currentUrl.indexOf( "&add=yes" ) > -1)
			history.replaceState( {} , '', currentUrl.replace(/&add=yes/g, "") );

		var o = $.PALM.options.popUpIframeOptions;
		var _this = this;

		// remove previous popup iframe if exist
		_this.remove(o);

		var targetContainer = $("body");
		if (self !== top) {
			targetContainer = $(window.parent.document.body);
		}

		// combine options
		if (typeof popUpOptions != "undefined")
			o = $.extend(o, popUpOptions);

		// get popUp content
		var iframeObject = $('<iframe/>').attr({
			"width" : "1",
			"height" : "1",
			"width" : "1",
			"scrolling" : "yes",
			"frameborder" : "no",
			"marginheight" : "0",
			"marginwidth" : "0",
			"border" : "0",
			"src" : iframeUrl
		}).addClass("externalContent");

		var popUpContainer = $('<div/>').addClass(
				o.popUpIframeClasses.dialogContent).css({
			width : o.popUpWidth,
			height : o.popUpHeight,
			margin : o.popUpMargin
		}).append(
				$('<div/>').addClass(o.popUpIframeClasses.dialogCloseContainer)
						.append(
								$('<i/>').addClass(
										o.popUpIframeClasses.dialogCloseButton)
										.click(function() {
											_this.remove(o)
										})));

		if (typeof iframeTitle !== "undefined") {
			popUpContainer.append($('<div/>').addClass(
					o.popUpIframeClasses.dialogHeader).html(iframeTitle));
		}

		popUpContainer.append(iframeObject)

		// create new popUp
		var popUpModal = $('<div/>').addClass(
				o.popUpIframeClasses.modalContainer).append(
				$('<div/>').addClass(o.popUpIframeClasses.modalOverlay))
				.append(
						$('<div/>').addClass(
								o.popUpIframeClasses.dialogContainer).append(
								popUpContainer).on("click", function(e) {
							_this.remove(o)
						}));

		// put popup into body
		targetContainer.append(popUpModal);

		/* add blur */
		var blurBackground = targetContainer.find(".wrapper");
		blurBackground.addClass("blur2px");

		// put into PALM object
		o.popUpIframe.push(popUpModal);
		o.blurBackground = blurBackground;
	},
	remove : function(options) {
		// if on iframe
		if (self !== top) {
			options = parent.$.PALM.options.popUpIframeOptions;
		}
		if (options.popUpIframe.length > 0) {
			// remove element from DOM
			options.popUpIframe[0].remove();
			// clear array
			options.popUpIframe = [];
			// remove blur
			/* remove blur */
			options.blurBackground.removeClass("blur2px");
		}
	}
};

/**
 * PopUp Ajax Modal ============= Plugin for handling pop up ajax content as
 * modal dialog
 */

$.PALM.popUpAjaxModal = {
	load : function(urlPart) {
		var _this = this;
		var jqxhr = $.get(baseUrl + "/" + urlPart, function(html) {
			// removing query string
			var formType = urlPart.split("?");
			_this.open(formType[0], html);
		}).done(function() {
			// nothing to do
		}).fail(function() {
			// nothing to do
		}).always(function() {
			// nothing to do
		});
	},
	open : function(popUpType, html) {
		// remove existing popup if exist
		this.remove();

		/* add blur */
		$(".wrapper").addClass("blur2px");

		// create new pop up
		this.activePopUpModal = $("<div/>").addClass("popup-form-container")
				.append($("<div/>").addClass("dialog-overlay")).append(
						$("<div/>").addClass(popUpType + "-container").html(
								html)).appendTo("body");
	},
	remove : function() {
		if (typeof this.activePopUpModal !== "undefined") {
			$(this.activePopUpModal).remove();
			$(".wrapper").removeClass("blur2px");
		} else {
			if (window.location.href.indexOf("login") > -1)
				window.location = baseUrl;
		}
	}
}

/**
 * Generate callout information box
 */
$.PALM.callout = {
	generate : function(containerElement, type, title, content) {
		var calloutClass = "callout";
		if (type == "warning")
			calloutClass += " callout-warning";

		var callOutBlock = $('<div/>').addClass(calloutClass).append(
				$('<h4/>').html(title)).append($('<p/>').html(content));

		containerElement.append(callOutBlock);

	}
}

/**
 * PALM xs javascript, get closest form, serialize and getJSON
 */
$.PALM.api = {
	submit : function($trigerElem) {
		var _this = this;
		var $closestForm = $trigerElem.closest("form");
		// add overlay
		var overlay = $('<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>');
		$closestForm.append(overlay);
		
		var domainPort = location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: '');
		var url = domainPort +  $closestForm.attr("action") + "?" + $closestForm.serialize();
		
		$closestForm.find( ".queryAPI" ).val( url );

		var jqXHR = $.getJSON( $closestForm.attr("action"), $closestForm.serialize(), function( data ) {
			// remove overlay and loading
			$closestForm.find(".overlay").remove();
			// print json
			$closestForm.find( ".textarea" ).html( _this.jsonTidy( JSON.stringify(data, undefined, 4)) );
		});
	},
	jsonTidy: function ( json ){
		// http://jsfiddle.net/KJQ9K/554/
		json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
	    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
	        var cls = 'pre-number';
	        if (/^"/.test(match)) {
	            if (/:$/.test(match)) {
	                cls = 'pre-key';
	            } else {
	                cls = 'pre-string';
	            }
	        } else if (/true|false/.test(match)) {
	            cls = 'pre-boolean';
	        } else if (/null/.test(match)) {
	            cls = 'pre-null';
	        }
	        return '<span class="' + cls + '">' + match + '</span>';
	    });
	}
}

/**
 * PALM bookmark functionalities
 */
$.PALM.bookmark = {
	author : function( bookButton, userId, authorId ) {
		var _this = this;
		var goal = bookButton.attr( "data-goal" );
		if( !_this.ajaxRunning ){
			_this.ajaxRunning = true;
			if( goal == "add" )
				_this.addBookmark( bookButton, "researcher", "user/bookmark/author"  ,{ "userId" : userId , "bookId" : authorId });
			else
				_this.removeBookmark( bookButton, "researcher", "user/bookmark/remove/author"  ,{ "userId" : userId , "bookId" : authorId });
		}
	},
	publication : function( bookButton, userId, publicationId ) {
		var _this = this;
		var goal = bookButton.attr( "data-goal" );
		if( !_this.ajaxRunning ){
			_this.ajaxRunning = true;
			if( goal == "add" )
				_this.addBookmark( bookButton, "publication", "user/bookmark/publication"  ,{ "userId" : userId , "bookId" : publicationId });
			else
				_this.removeBookmark( bookButton, "publication", "user/bookmark/remove/publication"  ,{ "userId" : userId , "bookId" : publicationId });
		}
	},
	circle : function( bookButton, userId, circleId ) {
		var _this = this;
		var goal = bookButton.attr( "data-goal" );
		if( !_this.ajaxRunning ){
			_this.ajaxRunning = true;
			if( goal == "add" )
				_this.addBookmark( bookButton, "circle", "user/bookmark/circle"  ,{ "userId" : userId , "bookId" : circleId });
			else
				_this.removeBookmark( bookButton, "circle", "user/bookmark/remove/circle"  ,{ "userId" : userId , "bookId" : circleId });
		}
	},
	eventGroup : function( bookButton, userId, eventGroupId ) {
		var _this = this;
		var goal = bookButton.attr( "data-goal" );
		if( !_this.ajaxRunning ){
			_this.ajaxRunning = true;
			if( goal == "add" )
				_this.addBookmark( bookButton, "eventGroup", "user/bookmark/eventGroup"  ,{ "userId" : userId , "bookId" : eventGroupId });
			else
				_this.removeBookmark( bookButton, "eventGroup", "user/bookmark/remove/eventGroup"  ,{ "userId" : userId , "bookId" : eventGroupId });
		}
	},
	addBookmark: function (bookButton, type, url, parameters) {
		var _this = this;
	    $.post( baseUrl + "/" + url  , parameters , function( data) {
		   if( data.status == "ok" ){
			   bookButton
			   	.attr( "data-goal" , "remove" )
			   	.addClass( "active" );
			   // change label
			   if( type == "researcher" ){
				   bookButton.find( "i" ).removeClass( "fa-user-plus" ).addClass( "fa-check" );
				   bookButton.find( "strong" ).html( "Followed" );
			   } else {
				   bookButton.find( "i" ).removeClass( "fa-bookmark" ).addClass( "fa-check" );
				   bookButton.find( "strong" ).html( "Bookmarked" );
			   }
		   }
		   _this.ajaxRunning = false;
	   });
	},
	removeBookmark: function ( bookButton, type, url, parameters) {
		var _this = this;
	    $.post( baseUrl + "/" + url  , parameters , function( data) {
		   if( data.status == "ok" ){
			   bookButton
			   	.attr( "data-goal" , "add" )
			   	.removeClass( "active" );
			   // change label
			   if( type == "researcher" ){
				   bookButton.find( "i" ).removeClass( "fa-check" ).addClass( "fa-user-plus" );
				   bookButton.find( "strong" ).html( "Follow" );
			   } else {
				   bookButton.find( "i" ).removeClass( "fa-check" ).addClass( "fa-bookmark" );
				   bookButton.find( "strong" ).html( "Bookmark" );
			   }
		   }
		   _this.ajaxRunning = false;
	   });
	}
};

/**
 * Collections of utility functionalities on PALM
 */
$.PALM.utility = {
	generateUniqueId : function() {
		var aplhaNumeric = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
		var randomAlphanumeric = "";
		for (var i = 10; i > 0; --i)
			randomAlphanumeric += aplhaNumeric[Math.round(Math.random()
					* (aplhaNumeric.length - 1))];
		return randomAlphanumeric;
	},
	stripHtmlTag : function(inputText) {
		var div = document.createElement("div");
		div.innerHTML = inputText;
		return div.textContent || div.innerText || "";
	},
	// date format YYYY-mm-dd
	parseDateType1 : function(inputDate) {
		var splitDate = inputDate.split("/");
		if (splitDate.length == 0)
			return "";
		if (splitDate.length == 1)
			return inputDate;

		var outputDate = "";
		if (splitDate[1] == "1")
			outputDate += "Jan";
		else if (splitDate[1] == "2")
			outputDate += "Feb";
		else if (splitDate[1] == "3")
			outputDate += "Mar";
		else if (splitDate[1] == "4")
			outputDate += "Apr";
		else if (splitDate[1] == "5")
			outputDate += "May";
		else if (splitDate[1] == "6")
			outputDate += "Jun";
		else if (splitDate[1] == "7")
			outputDate += "Jul";
		else if (splitDate[1] == "8")
			outputDate += "Aug";
		else if (splitDate[1] == "9")
			outputDate += "Sep";
		else if (splitDate[1] == "10")
			outputDate += "Oct";
		else if (splitDate[1] == "11")
			outputDate += "Nov";
		else if (splitDate[1] == "12")
			outputDate += "Dec";

		if (splitDate.length == 3)
			return splitDate[2] + " " + outputDate + " " + splitDate[0];
		else
			return outputDate + " " + splitDate[0];
	},
	cutStringWithoutCutWord : function(inputText, maxLength) {

		if (inputText.length > maxLength) {
			// trim the string to the maximum length
			var trimmedString = inputText.substr(0, maxLength);

			// re-trim if we are in the middle of a word
			trimmedString = trimmedString.substr(0, Math.min(
					trimmedString.length, trimmedString.lastIndexOf(" ")));

			return trimmedString;
		} else
			return inputText;
	},
	removeURLParameter: function (url, parameter) {
	    //prefer to use l.search if you have a location/link object
	    var urlparts= url.split('?');   
	    if (urlparts.length>=2) {

	        var prefix= encodeURIComponent(parameter)+'=';
	        var pars= urlparts[1].split(/[&;]/g);

	        //reverse iteration as may be destructive
	        for (var i= pars.length; i-- > 0;) {    
	            //idiom for string.startsWith
	            if (pars[i].lastIndexOf(prefix, 0) !== -1) {  
	                pars.splice(i, 1);
	            }
	        }

	        url= urlparts[0]+'?'+pars.join('&');
	        if((url.indexOf("?") == -1))
	        	url += "?";
	        return url;
	    } else {
	    	if((url.indexOf("?") == -1))
	        	url += "?";
	        return url;
	    }
	}
};

$.PALM.postForm = {
	viaAjax : function($form, resultContainerSelector) {

	},
	viaAjaxAndReload : function($form, message, reloadurl) {
		// pop up message
		var popUpId = $.PALM.popUpMessage.create(message, {
			popupType : "loading",
			directlyRemove : false
		});
		// sent form content via ajax POST
		$
				.post($form.attr("action"), $form.serialize())
				.done(
						function(jsonData) {
							if (jsonData.format == "json") {
								if (jsonData.status == "ok") {
									$.PALM.popUpMessage.remove(popUpId);

									var targetElement = $.PALM.popUpMessage
											.getPopUpObject(popUpId);
									// reload page afteranimation complete
									$(targetElement).promise().done(function() {
										if (typeof reloadurl !== "undefined")
											window.location.href = reloadurl;
										else
											window.location.reload(false);
									});
								} else
									$.PALM.popUpMessage
											.create(
													"Sorry, saving process failed please try again",
													{
														popupType : "error"
													});
							} else {
								$.PALM.popUpMessage
										.create(
												"Sorry, saving process failed please try again",
												{
													popupType : "error"
												});
							}
						})
				.fail(
						function(xhr, textStatus, errorThrown) {
							$.PALM.popUpMessage.remove(popUpId);
							$.PALM.popUpMessage
									.create(
											"Sorry, saving process failed please try again",
											{
												popupType : "error"
											});
						});
	}
};

/**
 * Validation plugin or PALM input, just add validation attribute, such as
 * data-validation="required,email,checkduplication"
 * data-validationDuplicationUrl="/user/isUsernameExist" Note: checking based on
 * order
 */
/* Validation plugin is subtituted by jquery.validation */
// $.PALM.validation = {
// activate: function ( containerSelector ){
// // find any input or textarea on the container
// $( containerSelector ).find( )
// }
// }
/**
 * get form via ajax
 */
function getFormViaAjax(url, alwaysCallback) {
	var jqxhr = $.get(baseUrl + "/" + url, function(html) {
		// removing query string
		var formType = url.split("?");
		getPopUpForm(formType[0], html);
	}).done(function() {
		// nothing to do
	}).fail(function() {
		// nothing to do
	}).always(function() {
		if (typeof alwaysCallback !== "undefined")
			alwaysCallback
	});
}
/**
 * Get popup form and display it
 */
function getPopUpForm(popUpType, html) {
	// remove existing popup if exist
	$(".popup-form-container").remove();
	/* add blur */
	$(".wrapper").addClass("blur2px");

	// create new one
	var $popUpElem = $("<div/>").addClass("popup-form-container").append(
			$("<div/>").addClass("dialog-overlay")).append(
			$("<div/>").addClass(popUpType + "-container").html(html))
			.appendTo("body");
}

/*
 * BOX REFRESH BUTTON ------------------ This is a custom plugin to use with the
 * compenet BOX. It allows you to add a refresh button to the box. It converts
 * the box's state to a loading state.
 * 
 * @type plugin @usage $("#box-widget").boxRefresh( options );
 */
(function($) {

	$.fn.boxRefresh = function(options) {

		// Render options
		var settings = $.extend({
			// Refressh button selector
			trigger : ".refresh-btn",
			// File source to be loaded (e.g: ajax/src.php)
			source : "",
			// Callbacks
			onLoadStart : function(box) {
			}, // Right after the button has been clicked
			onLoadDone : function(box) {
			} // When the source has been loaded

		}, options);

		// The overlay
		var overlay = $('<div class="overlay"><div class="fa fa-refresh fa-spin"></div></div>');

		return this
				.each(function() {
					// if a source is specified
					if (settings.source === "") {
						if (console) {
							console
									.log("Please specify a source first - boxRefresh()");
						}
						return;
					}
					// the box
					var box = $(this);
					// the button
					var rBtn = box.find(settings.trigger).first();

					// On trigger click
					rBtn.click(function(e) {
						e.preventDefault();
						// Add loading overlay
						start(box);

						// Perform ajax call
						box.find(".box-body").load(settings.source, function() {
							done(box);
						});
					});
				});

		function start(box) {
			// Add overlay and loading img
			box.append(overlay);

			settings.onLoadStart.call(box);
		}

		function done(box) {
			// Remove overlay and loading img
			box.find(overlay).remove();

			settings.onLoadDone.call(box);
		}

	};

})(jQuery);

/*
 * TODO LIST CUSTOM PLUGIN ----------------------- This plugin depends on iCheck
 * plugin for checkbox and radio inputs
 * 
 * @type plugin @usage $("#todo-widget").todolist( options );
 */
(function($) {

	$.fn.todolist = function(options) {
		// Render options
		var settings = $.extend({
			// When the user checks the input
			onCheck : function(ele) {
			},
			// When the user unchecks the input
			onUncheck : function(ele) {
			}
		}, options);

		return this.each(function() {

			if (typeof $.fn.iCheck != 'undefined') {
				$('input', this).on('ifChecked', function(event) {
					var ele = $(this).parents("li").first();
					ele.toggleClass("done");
					settings.onCheck.call(ele);
				});

				$('input', this).on('ifUnchecked', function(event) {
					var ele = $(this).parents("li").first();
					ele.toggleClass("done");
					settings.onUncheck.call(ele);
				});
			} else {
				$('input', this).on('change', function(event) {
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
function getContentViaAjax(url, containerSelector, alwaysCallback) {
	var jqxhr = $.get(url, function(html) {
		$(containerSelector).html(html);
	}).done(function() {
		// nothing to do
	}).fail(function() {
		// nothing to do
	}).always(function() {
		if (typeof alwaysCallback !== "undefined")
			alwaysCallback
	});
}

function postFormViaAjax($form, resultContainerSelector) {
	// TODO input check

	// sent form content via ajax POST
	$.post($form.attr("action"), $form.serialize(), function(jsonData) {
		if (jsonData.format == "json") {
			console.log(jsonData.result);
		} else if (jsonData.format == "javascript") {

		} else {// html

		}
	});

	return false;
}

function postFormAndReloadPageViaAjax($form, message) {

	// sent form content via ajax POST
	$.post($form.attr("action"), $form.serialize(), function(jsonData) {
		if (jsonData.format == "json") {
			console.log(jsonData.result);
		} else if (jsonData.format == "javascript") {

		} else {// html

		}
	});

	return false;
}

/**
 * Get popup form and display it
 */
function getPopUpIframe(url) {
	// remove existing popup if exist
	$(".popup-form-container").remove();
	/* add blur */
	$(".wrapper").addClass("blur2px");

	// create new one
	var $popUpElem = $("<div/>")
			.addClass("popup-form-container")
			.append($("<div/>").addClass("dialog-overlay"))
			.append(
					$("<div/>")
							.addClass("iframe-center-container")
							.append(
									$("<div/>")
											.addClass("iframe-container")
											.append(
													'<iframe class="externalContent" alt="external source" width="1" height="1" scrolling="yes" frameborder="no" marginheight="0" marginwidth="0" border="0" src="'
															+ url
															+ '"></iframe>')))
			.appendTo("body");
}

/* jQuery ajax get */
/*
 * function getContentViaAjax( url, containerSelector ){ $( containerSelector
 * ).addClass( "ajax-loading-image" ); var jqxhr = $.ajax( url ) .done(function(
 * html ) { $( containerSelector ).html( html ); }) .fail(function() { })
 * .always(function() { $( containerSelector ).removeClass( "ajax-loading-image" );
 * }); }
 */

function getDialogOptions(dialogTitle, dialogWidth, dialogHeight, isModal,
		isResizeble, isDraggable, buttonSelector) {
	if (typeof isModal == "undefined")
		isModal = false;
	if (typeof isResizeble == "undefined")
		isResizeble = true;
	if (typeof isModal == "undefined")
		isDraggable = true;
	// dialog options
	var dialogOptions = {
		"title" : dialogTitle,
		"width" : dialogWidth,
		"height" : dialogHeight,
		"modal" : isModal,
		"resizable" : isResizeble,
		"draggable" : isDraggable,
		"close" : function() {
			$(buttonSelector).removeClass("current");
		}
	};
	return dialogOptions;
}

function getDialogExtendOptions(isClosable, isMaximizable, isMinimizable) {
	if (typeof isClosable == "undefined")
		isClosable = true;
	if (typeof isMaximizable == "undefined")
		isMaximizable = true;
	if (typeof isMinimizable == "undefined")
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
 * Convert any input type files into jquery multiple file upload $fileSelector -
 * required - the input files must be jquery object $progressSelector - required -
 * the progress bar must be jquery object
 */
function convertToAjaxMultipleFileUpload($inputFile, $progressBar,
		$resultContainer) {
	var $container = null;
	if ($resultContainer instanceof jQuery)
		$container = $resultContainer;
	else
		$container = $($resultContainer);

	$inputFile.fileupload({
		dataType : 'json',

		done : function(e, data) {
			$container.find("#title").val(data.result.title);
			$container.find("#author").val(data.result.author);
			$container.find("#abstractText").val(data.result.abstract);
			$container.find("#keywords").val(data.result.keyword);
			$container.find("#contentText").val(data.result.content);
			$container.find("#referenceText").val(data.result.reference);
		},

		progressall : function(e, data) {
			var progress = parseInt(data.loaded / data.total * 100, 10);
			$progressBar.find('.bar').css('width', progress + '%').html(
					progress + '%');
			$progressBar.show();
			if (progress == 100)
				window.setTimeout(function() {
					$progressBar.fadeOut("slow");
				}, 3000);
		}
	});
}

function printUploadedArticles($containerSelector, data, addedOptions) {
	var $container = null;
	if ($containerSelector instanceof jQuery)
		$container = $containerSelector;
	else
		$container = $($containerSelector);

	/* check if textarea available */
	if ($container.find("textarea").length == 0) {
		$container.append($('<textarea/>').css({
			'width' : '99%',
			'height' : "410px",
			'resize' : 'none'
		})).css({
			'width' : '100%',
			'height' : "450px"
		}).resizable({
			resize : function(event, ui) {
				$(this).find("textarea").css({
					'width' : (ui.element.width() - 10) + 'px',
					'height' : (ui.element.height() - 40) + 'px'
				});
			}
		});
	}

	var textareaVal = $container.find("textarea").val();
	var appendedVal = "uploaded " + data.id + " \t " + data.title + "\n";

	$container.find("textarea").val(textareaVal + appendedVal);

}

function inIframe() {
	try {
		return window.self !== window.top;
	} catch (e) {
		return true;
	}
}