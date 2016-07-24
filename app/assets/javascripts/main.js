$(document).ready(function() {
  createAccount();
  signIn();
  hideGamePlayButtons();
  hideButtonById("join")
  hideButtonById("pocket_cards")
  hideButtonById("play")
  initiateBet();
  makeBet();
});
