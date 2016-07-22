function createAccount() {
  $("#create-account").on("click", function() {
    $(".create-account").fadeIn();
    $(".sign-in").fadeOut();
  });
}

function signIn() {
  $("#sign-in").on("click", function() {
    $(".sign-in").fadeIn();
    $(".create-account").fadeOut();
  });
}
