$(document).ready(function() {
  $(".little-blind").on("click", function(event) {
    $("#little-blind").append(event.target.text)
  })
})
