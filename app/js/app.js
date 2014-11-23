var store = null;
if(!localStorage["visited"]) localStorage["visited"] = {};

$(function() {
  $(document).on("dragstart", "a, img", false);

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
