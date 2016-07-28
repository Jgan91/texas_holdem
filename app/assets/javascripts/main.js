$(document).ready(function() {
  createAccount();
  signIn();
  hideButtonById("join")
  hideButtonById("pocket_cards")
  $("#pocket_cards").hide()
  hideButtonById("play")
  initiateBet();
  makeBet();
  hideFold();
  hideCheck();
});
