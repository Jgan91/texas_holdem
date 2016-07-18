require "rails_helper"

RSpec.feature "user can login" do
  scenario "user goes to game room" do
    User.create(username: "jones", password: "123")

    visit root_path

    within(".sign-in") do
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"

      click_on "Sign in"
    end

    expect(current_path).to eq rooms_path
  end

  scenario "user sees login fields again" do

    visit root_path
    within(".sign-in") do
      fill_in "Username", with: "frank"
      fill_in "Password", with: "123"
    end

    click_on "Sign in"

    expect(current_path).to eq root_path
  end
end
