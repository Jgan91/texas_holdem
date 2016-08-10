require "rails_helper"

RSpec.feature "user can play poker" do
  scenario "user sees results of the game" do
    ai = AiPlayer.create(username: "Rosco", cash: 1000)
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    visit root_path

    within(".sign-in") do
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"
      click_on "Sign in"
    end
    click_on "Play"

    expect(current_path).to eq rooms_path

    click_on "Add AI Player"
    click_on "Join"
    click_on "Start Game"
    Game.update(ordered_players: ["a" + ai.id.to_s, user.id])
    expect(page).to have_button "Bet / Raise"
    expect(page).to have_button "Check / Call"
    expect(page).to have_button "Fold"

    click_on "Check / Call"
    click_on "Fold"

    expect(Game.last.stage).to eq nil
    expect(Game.last.find_players).to eq [ai, user]
    # user = User.last
    # expect(page).to have_content "Flop:"
    #
    # click_on "Check"
    # expect(page).to have_content "Rosco Checks"
    # click_on "Deal Turn"
    #
    # game_w_turn = Game.last
    #
    # expect(page).to have_content "Pocket:"
    # expect(page).to have_content "Flop:"
    # expect(page).to have_content "Turn:"
    #
    # click_on "Check"
    #
    # expect(page).to have_content "Rosco Checks"
    # click_on "Deal River"
    #
    # game_w_river = Game.last
    #
    # expect(page).to have_content "Pocket:"
    # expect(page).to have_content "Flop:"
    # expect(page).to have_content "Turn:"
    # expect(page).to have_content "River:"
    #
    # click_on "Check"
    #
    # expect(page).to have_content "Rosco Checks"
    # click_on "Show Winner"
    # expect(page).to have_content game.winner
  end
end
