controllers.show = function(key) {
  var _this = this;

  var story = _.find(store, function(story) {
    return story.key == key;
  });

  this.init = function() {
    console.log("starting show");

    $.get(story.url, function(data) {
      console.log(data);
    });

    $("#view-show").show().addClass("current-view");

    //setTimeout(preloadImages, 5000);
  }

  this.render = function() {
    var index = utils.page();

  }

  this.destroy = function() {
    console.log("destroying show");
    $("#view-show").hide().removeClass("current-view");
  }
}

