controllers.index = function(search, sort, sortDirection) {
  var _this = this;

  function sortFor(type) {
    if(!type) type = "publishedOn";

    if(type == "publishedOn") return function(story) {
      return story.publishedOn;
    };
    if(type == "wordCount") return function(story) {
      return story.wordCount;
    };
  }

  var storys = store;
  if(search && search != "") {
    regex = RegExp(search, "i");
    storys = _.filter(storys, function(story) {
      return story.title.match(regex);
    });
  }
  storys = _.sortBy(storys, sortFor(sort));

  if(!sortDirection) sortDirection = "desc";
  if(sortDirection == "desc") storys = storys.reverse();

  function perPageFromWindow() {
    var windowWidth = $(window).width();
    if(windowWidth < 1000) return 15;
    else if(windowWidth > 1000 && windowWidth < 1500) return 20;
    else if(windowWidth > 1500) return 25;
  }

  var perPage = perPageFromWindow();
  var pages = utils.pages(storys, perPage);

  this.init = function() {
    console.log("starting index");

    $("#search").bind("keydown", function(event) {
      if(event.keyCode == 13) {
        event.preventDefault();
        utils.location({ params: [$("#search").val(), sort, sortDirection], hash: "1" });
      }
    });

    $("#clear-search").bind("click", function() {
      $("#search").val("");
    });

    $("a.sort").bind("click", function(event) {
      event.preventDefault();
      utils.location({ params: [search, $(this).data("sort"), sortDirection], hash: "1" });
    });

    $("a.sort-direction").bind("click", function(event) {
      event.preventDefault();
      utils.location({ params: [search, sort, $(this).data("sort-direction")], hash: "1" });
    });

    $("#view-index").hammer().on("drag swipeleft swiperight", function(event) {
      if(Hammer.utils.isVertical(event.gesture.direction)) return;
      event.gesture.preventDefault();

      if(event.type == 'swipeleft') utils.page(utils.page() + 1, pages);
      else if(event.type == 'swiperight') utils.page(utils.page() - 1, pages);
    });

    $("#view-index").show().addClass("current-view");
    $.twoup.layout();
  }

  function addStorys(storys) {
    $("#stories").empty();

    _.each(storys, function(story) {
      var item = $("<li>");
      var link = $("<a>");
      link.attr("href", "#show/" + story.key + "!1");
      link.text(story.title);
      item.append(link);

      $("#stories").append(item);
    });
  }

  this.render = function() {
    console.log("rendering");
    var storysPage = utils.paginate(storys, perPage);
    addStorys(storysPage);
  }

  this.destroy = function() {
    console.log("destroying index");
    $("#search").unbind("keydown");
    $("#clear-search").unbind("click");
    $("a.sort").unbind("click");
    $("a.sort-direction").unbind("click");
    $("#items").empty();
    $("#view-index").hammer().off("swiperight").off("swipeleft").off("drag");
    $("#view-index").hide().removeClass("current-view");
  }
}
