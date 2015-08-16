jQuery(document).ready(function($) {
  var body = $("body");
  function s1_toggle() {
    body.toggleClass("s1-collapse").toggleClass("s1-expand");
  }
  function s2_toggle() {
    body.toggleClass("s2-collapse").toggleClass("s2-expand");
  }
  $(".s1 .sidebar-toggle").click(function() {
    s1_toggle();
    if(body.is(".s2-expand")) { s2_toggle(); }
  });
  $(".s2 .sidebar-toggle").click(function() {
    s2_toggle();
    if(body.is(".s1-expand")) { s1_toggle(); }
  });
});
