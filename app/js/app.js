var store = null;
if(!localStorage["visited"]) localStorage["visited"] = {};

$(function() {
  $(document).on("dragstart", "a, img", false);

  $(window).bind('hashchange', function() {
    $(window).scrollTop((utils.page() - 1) * Math.max(0, $(window).height() - 51 - 60));
  }).trigger('hashchange');

  $("#page-back").click(function(e) {
    e.stopPropagation();
    utils.page(utils.page() - 1);
  });
  $("#page-back-10").click(function(e) {
    e.stopPropagation();
    utils.page(utils.page() - 10);
  });
  $("#page-next").click(function(e) {
    e.stopPropagation();
    utils.page(utils.page() + 1);
  });
  $("#page-next-10").click(function(e) {
    e.stopPropagation();
    utils.page(utils.page() + 10);
  });
  $("#page-home").click(function(e) {
    e.stopPropagation();
    location.hash = lastControllerLocation;
  });

  $.getJSON("data.json").done(function(data) {
    if(data.length == 0) alert("No data.json, or data invalid.");

    store = data;

    window.router = new router();
    router.init();
    if(location.hash == "#" || location.hash == "") location.hash = "#index!1";
  });
});
