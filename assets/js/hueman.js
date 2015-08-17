jQuery(document).ready(function($) {
  var body = $("body");
  function s1Toggle() {
    body.toggleClass("sidebar-1-collapse").toggleClass("sidebar-1-expand");
  }
  function s2Toggle() {
    body.toggleClass("sidebar-2-collapse").toggleClass("sidebar-2-expand");
  }
  $(".sidebar-1 .sidebar-toggle").click(function() {
    s1Toggle();
    if(body.is(".sidebar-2-expand")) { s2Toggle(); }
  });
  $(".sidebar-2 .sidebar-toggle").click(function() {
    s2Toggle();
    if(body.is(".sidebar-1-expand")) { s1Toggle(); }
  });

  /* Demarque odd rows */
  var oddRows = $("tr:odd");
  for(var i = 0; i < oddRows.length; i++) {
    oddRows[i].classList.add("alt");
  }
});
