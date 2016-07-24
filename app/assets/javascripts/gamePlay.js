
function hideGamePlayButtons(){
  $("#start-game").on("click", function() {
    $(".pregame").fadeOut()
  });
};

function initiateBet() {
  $("#current-bet").on("click", function() {
    $(".bet-form").fadeOut();
    $(".action").fadeIn();
  });
}

function makeBet() {
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
}

function hideButtonById(id) {
  $("#" + id).on("click", function() {
    $("#" + id).fadeOut()
  })
}
