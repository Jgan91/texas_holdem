function initiateBet() {
  $("#current-bet").on("click", function() {
    $(".bet-form").fadeOut();
    $(".action").fadeIn();
    $(".container-action").fadeOut()
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

function hideFold() {
  $("#fold").on("click", function() {
    $(".container-action").fadeOut()
  })
}

function hideCheck() {
  $("#check").on("click", function() {
    $(".container-action").fadeOut()
  })
}
