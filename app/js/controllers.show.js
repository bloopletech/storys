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
      iframe.remove();
    });
    iframe.attr("src", url);
  }

  this.init = function() {
    console.log("starting show");
    loadStory(story.url);
    $("#view-show").show().addClass("current-view");
  }

  this.render = function() {
    var index = utils.page();

  }

  this.destroy = function() {
    console.log("destroying show");
    $("#story").empty();
    $("#view-show").hide().removeClass("current-view");
  }
}

