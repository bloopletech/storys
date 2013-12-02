var lastControllerLocation = "#index!1";

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
    if(type == "title") return function(story) {
      return story.title.toLowerCase();
    };
  }

  var storys = store;
  if(search && search != "") {
    var words = search.split(/\s+/);
    _.each(words, function(word) {
      regex = RegExp(word, "i");
      storys = _.filter(storys, function(story) {
        return story.title.match(regex);
      });
    });
  }
  if(!sort) sort = "publishedOn";
  storys = _.sortBy(storys, sortFor(sort));

  if(!sortDirection) sortDirection = "desc";
  if(sortDirection == "desc") storys = storys.reverse();

  storys = _.first(storys, 500);

  function addStorys(storys) {
    if($("#stories > li").length) return;

    _.each(storys, function(story) {
      var item = $("<li>");
      var link = $("<a>");
      link.attr("href", "#show/" + story.key + "!1");

      link.append($("<span title='Story title'>").text(story.title));
      var emblems = $("<div class='emblems'>");
      emblems.append($("<span class='wc' title='Page count of story'>").text(Math.ceil(story.wordCount / 300)));
      link.append(emblems);

      item.append(link);

      $("#stories").append(item);
    });
  }

  this.init = function() {
    console.log("starting index");

    $("#search").bind("keydown", function(event) {
      event.stopPropagation();
      if(event.keyCode == 13) {
        event.preventDefault();
        utils.location({ params: [$("#search").val(), sort, sortDirection], hash: "1" });
      }
    });

    $("#clear-search").bind("click", function() {
      $("#search").val("");
      event.preventDefault();
      location.href = "#index!1";
    });

    $(".sort button").bind("click", function(event) {
      event.preventDefault();
      utils.location({ params: [search, $(this).data("sort"), sortDirection], hash: "1" });
    });

    $(".sort button").removeClass("active");
    $(".sort button[data-sort=" + sort + "]").addClass("active");

    $(".sort-direction button").bind("click", function(event) {
      event.preventDefault();
      console.log("clicked sorter", $(this).data("sort-direction"));
      utils.location({ params: [search, sort, $(this).data("sort-direction")], hash: "1" });
    });

    $(".sort-direction button").removeClass("active");
    $(".sort-direction button[data-sort-direction=" + sortDirection + "]").addClass("active");

    $("#view-index").show().addClass("current-view");
    addStorys(storys);
    $.twoup.layout();
  }

  this.render = function() {
    lastControllerLocation = location.hash;
  }

  this.destroy = function() {
    console.log("destroying index");
    $("#search").unbind("keydown");
    $("#clear-search").unbind("click");
    $(".sort button").unbind("click");
    $(".sort-direction button").unbind("click");
    $("#stories").empty();
    $("#view-index").hide().removeClass("current-view");
  }
}
