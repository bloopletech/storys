var store = null;

$(function() {
  $(document).on("dragstart", "a, img", false);

  $("#wrapper").twoup("none");

  $("#page-back").click(function(e) {
    e.stopPropagation();
    $.twoup.page(-1, true);
  });
  $("#page-back-10").click(function(e) {
    e.stopPropagation();
    $.twoup.page(-10, true);
  });
  $("#page-next").click(function(e) {
    e.stopPropagation();
    $.twoup.page(1, true);
  });
  $("#page-next-10").click(function(e) {
    e.stopPropagation();
    $.twoup.page(10, true);
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
