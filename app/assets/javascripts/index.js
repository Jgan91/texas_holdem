$(document).ready(function() {
  $("#create-account").on("click", function() {
    $(".create-account").fadeIn()
    $(".sign-in").fadeOut()
  })

  $("#sign-in").on("click", function() {
    $(".sign-in").fadeIn()
    $(".create-account").fadeOut()
  })
})
