function makeBet() {
  $("#current-bet").on("click", function() {
    $(".bet-form").fadeOut();
    $(".action").fadeIn();
    $(".container-action").fadeOut()
    $("img").removeClass("transparent")
  });
}

function initiateBet() {
  $("#bet").on("click", function() {
    $(".action").fadeOut()
    $("img").addClass("transparent")
    $(".bet-form").fadeIn()
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
