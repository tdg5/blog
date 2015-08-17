jQuery(document).ready(function($) {
  var body = $("body");
  function s1_toggle() {
    body.toggleClass("sidebar-1-collapse").toggleClass("sidebar-1-expand");
  }
  function s2_toggle() {
    body.toggleClass("sidebar-2-collapse").toggleClass("sidebar-2-expand");
  }
  $(".sidebar-1 .sidebar-toggle").click(function() {
    s1_toggle();
    if(body.is(".sidebar-2-expand")) { s2_toggle(); }
  });
  $(".sidebar-2 .sidebar-toggle").click(function() {
    s2_toggle();
    if(body.is(".sidebar-1-expand")) { s1_toggle(); }
  });
});
