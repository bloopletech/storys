;(function($) {
  var columns = 0;
  var padding_width = 0;
  var content_width = 0;
  var scroll_width = 0;
  var content, slider, padding;

  //Cargo-culting from colorbox
  var twoup = $.fn.twoup = $.twoup = function(column_rule) {
    if(content) {
      alert("You already have a twoup!");
      return;
    }

    if(twoup.enabled()) {
      twoup.content = content = $("<div></div>").css({ "-webkit-column-rule": column_rule, "-moz-column-rule": column_rule, "column-rule": column_rule });
      twoup.slider = slider = $("<div></div>");
      twoup.padding = padding = $(this).css({ "overflow": "hidden" });

      var children = padding.children().detach();
      padding.append(slider);
      slider.append(content);
      content.append(children);

      $(window).resize(twoup.layout).resize();

      $(window).bind('hashchange', function() {
        slider.animate({ "margin-left": -((twoup.page() - 1) * scroll_width) + "px" }, 300);
      }).trigger('hashchange');
    }
    else {
      $(window).bind('hashchange', function() {
        $("body").animate({ scrollTop: (twoup.page() - 1) * Math.max(0, $(window).height() - 60) }, 300);
      }).trigger('hashchange');
    }

    $(window).keydown(function(event) {
      if(event.keyCode == 32 || event.keyCode == 39) {
        event.preventDefault();
        twoup.page(1, true);
      }
      else if(event.keyCode == 8 || event.keyCode == 37) {
        event.preventDefault();
        twoup.page(-1, true);
      }
    });

    return this;
  };

  twoup.enabled = function() {
    //at the moment, only WebKit and MSIE10 has proper support for css3 columns AND getting the right width for a column element with overflow
    //at the moment, android and iphone scale the output weirdly, and their CPU can't really handle the multicolums on large pages
    return ($.browser.webkit || ($.browser.msie && $.browser.version >= 10)) && (!$.browser.android && !$.browser.iphone);
  }

  twoup.columns = function() {
    if(twoup.enabled()) {
      return Math.max(1, Math.floor($(window).width() / (18 * padding_width)));
    }
    else {
      return 1;
    }
  };

  twoup.column_width = function() {
    if(twoup.enabled()) {
      return parseInt(content.css("-webkit-column-width") || content.css("-moz-column-width") || content.css("column-width")); 
    }
    else {
      return content.width();
    }
  };

  twoup.pages = function() {
    if(twoup.enabled()) {
      return Math.ceil(content_width / scroll_width);
    }
    else {
      return Math.ceil($(document).height() / ($(window).height() - 60));
    }
  };

  twoup.bound_page_number = function(number) {
    var index = parseInt(number); 
    if(isNaN(index) || index < 1) index = 1;
    if(index > twoup.pages()) index = twoup.pages();

    return index;
  };

  twoup.page_spread = function() {
    var pages = [];
    for(var i = twoup.page(); i < twoup.pages(), pages.length < twoup.columns(); i++) pages.push(i);
    return pages;
  };

  twoup.page = function() {
    if(arguments.length == 2 && arguments[1]) twoup.page(twoup.page() + arguments[0]);
    else if(arguments.length == 1) utils.page(twoup.bound_page_number(arguments[0]));
    else return twoup.bound_page_number(utils.page());
  };

  twoup.layout = function() {
    if(!twoup.enabled()) return;

    padding_width = parseInt(padding.css("padding-top"));

    var old_columns = columns;
    columns = twoup.columns();

    var column_gap_width = (padding_width * 2) + parseInt(content.css("-webkit-column-rule-width") || content.css("column-rule-width"));
    var wrapper_width = window.innerWidth;
    var wrapper_height = window.innerHeight;
    var inner_width = wrapper_width - (padding_width * 2);
    var inner_height = wrapper_height - (padding_width * 2);
    var column_width = Math.floor((inner_width - (column_gap_width * (columns - 1))) / columns);
    scroll_width = inner_width + column_gap_width;

    padding.css({ "width": wrapper_width + "px", "height": wrapper_height + "px", "overflow": "hidden" });
    content.css({ "width": inner_width + "px", "height": inner_height + "px", "-webkit-column-width": column_width + "px",
     "-moz-column-width": column_width + "px", "column-width": column_width + "px", "-webkit-column-gap": column_gap_width + "px",
     "-moz-column-gap": column_gap_width + "px", "column-gap": column_gap_width + "px" });
    content_width = content[0].scrollWidth;

    if(columns != old_columns) $(window).trigger("onhashchange");
  };
})(jQuery);
