function createAccount() {
  $("#create-account").on("click", function() {
    $("img").addClass("transparent")
    $(".create-account").fadeIn();
    $(".sign-in").fadeOut();
  });
}

function signIn() {
  $("#sign-in").on("click", function() {
    $("img").addClass("transparent")
    $(".sign-in").fadeIn();
    $(".create-account").fadeOut();
  });
}

function submit() {
  $(".submit").on("click", function() {
    $("img").removeClass("transparent")
  })
}

function flash() {
  $(".error").delay(1000).fadeIn('normal', function() {
     $(this).delay(2000).fadeOut(1000);
  });
}
