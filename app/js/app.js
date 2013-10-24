var store = null;

$(function() {
  $(document).on("dragstart", "a, img", false);

  $("#wrapper").twoup("none");

  $("#page-back").click(function() {
    $.twoup.page(-1, true);
  });
  $("#page-next").click(function() {
    $.twoup.page(1, true);
  });
  $("#page-home").click(function() {
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
