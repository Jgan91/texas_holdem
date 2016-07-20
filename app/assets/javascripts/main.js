$(document).ready(function() {
  $("#begin-game").on("click", function() {
    $(".pregame").fadeOut()
  })

  $("#bet").on("click", function() {
    $(".action").fadeOut()
    $(".bet-form").fadeIn()
  })

  $("#current-bet").on("click", function() {
    $(".bet-form").fadeOut()
    $(".action").fadeIn()
  })
})
