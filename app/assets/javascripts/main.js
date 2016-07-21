$(document).ready(function() {
  hideGamePlayButtons();

  $("#bet").on("click", function() {
    $(".action").fadeOut()
    $(".bet-form").fadeIn()
  })
  $("#bet").keypress(function(event) {
    if (event.which == 13) {
      $(".action").fadeOut()
      $(".bet-form").fadeIn()
    }
  })

  $("#current-bet").on("click", function() {
    $(".bet-form").fadeOut();
    $(".action").fadeIn();
  });

  $("#create-account").on("click", function() {
    $(".create-account").fadeIn();
    $(".sign-in").fadeOut();
  });

  $("#sign-in").on("click", function() {
    $(".sign-in").fadeIn();
    $(".create-account").fadeOut();
  });

});
