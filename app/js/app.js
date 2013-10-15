var store = null;

$(function() {
  $(document).on("dragstart", "a, img", false);

  $("#wrapper").twoup("none");

  $.getJSON("data.json").done(function(data) {
    if(data.length == 0) alert("No data.json, or data invalid.");

    store = data;

    window.router = new router();
    router.init();
    if(location.hash == "#" || location.hash == "") location.hash = "#index!1";

    $("#wrapper").hammer().on("drag swipeleft swiperight", function(event) {
      if(Hammer.utils.isVertical(event.gesture.direction)) return;
      event.gesture.preventDefault();

      if(event.type == 'swipeleft') $.twoup.page(1, true);
      else if(event.type == 'swiperight') $.twoup.page(-1, true);
    });
  });
});
