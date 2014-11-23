controllers.show = function(key) {
  var _this = this;

  var story = _.find(store, function(story) {
    return story.key == key;
  });

  function loadStory(url) {
    var iframe = $("<iframe />");
    $("body").append(iframe);
    iframe.load(function() {
      $("#story").html(iframe[0].contentDocument.body.innerHTML);
      copyNavigation();
      iframe.remove();
    });
    iframe.attr("src", url);
  }

  function copyNavigation() {
    var headings = $("#story").find("h1,h2,h3,h4,h5,h6");
    $("#story-navigation").attr("label", $(headings[0]).text());
    _.each(headings, function(heading) {
      var a = $("<a>");
      a.bind("click", function(event) {
        event.preventDefault();
        $(heading)[0].scrollIntoView();
      });
      var cs = $("<core-item>").attr("label", $(heading).text()).append(a);
      $("#story-navigation core-selector").append(cs);
    });
  }

  function setVisited(key) {
    if(!localStorage["visited." + key]) localStorage["visited." + key] = "0";
    localStorage["visited." + key] = parseInt(localStorage["visited." + key]) + 1;
  }

  this.init = function() {
    console.log("starting show");
    $("#view-show").css("display", "flex").addClass("current-view");
    loadStory(story.url);
    setVisited(story.key);
  }

  this.render = function() {
  }

  this.destroy = function() {
    console.log("destroying show");
    $("#story").empty();
    $("#story-navigation a").unbind("click");
    $("#story-navigation core-selector").empty();
    $("#story-navigation").attr("label", "");
    $("#view-show").hide().removeClass("current-view");
  }
}

controllers.show.setup = function() {
};
