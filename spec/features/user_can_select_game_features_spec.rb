require "rails_helper"

RSpec.feature "user can select game settings" do
  scenario "user begins game with selected settings" do
    User.create(username: "jones", password: "123", email: "j@gmail.com")
    AiPlayer.create(username: "ai player")

    visit root_path

    within(".sign-in") do
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"

      click_on "Sign in"
    end

    click_on "Play"

    expect(current_path).to eq rooms_path

    expect(page).to have_content "Players"
    expect(page).to have_content "Little Blind: $"
    expect(page).to have_content "Big Blind: $"
    expect(page).to have_content "Buy In: $"
  end
end
