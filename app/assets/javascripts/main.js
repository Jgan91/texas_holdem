$(document).ready(function() {
  createAccount();
  signIn();
  submit();
  flash();
  hideButtonById("join");
  hideButtonById("pocket_cards");
  $("#pocket_cards").hide();
  hideButtonById("play");
  initiateBet();
  makeBet();
  hideFold();
  hideCheck();
});
