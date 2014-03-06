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
      $.twoup.layout();
      iframe.remove();
    });
    iframe.attr("src", url);
  }

  function setVisited(key) {
    if(!localStorage["visited." + key]) localStorage["visited." + key] = "0";
    localStorage["visited." + key] = parseInt(localStorage["visited." + key]) + 1;
  }

  this.init = function() {
    console.log("starting show");
    $("#view-show").show().addClass("current-view");
    loadStory(story.url);
    setVisited(story.key);
  }

  this.render = function() {
  }

  this.destroy = function() {
    console.log("destroying show");
    $("#story").empty();
    $("#view-show").hide().removeClass("current-view");
  }
}

controllers.show.setup = function() {
};
