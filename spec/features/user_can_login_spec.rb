require "rails_helper"

RSpec.feature "user can login" do
  scenario "user goes to game room" do
    user = User.create(username: "jones", password: "123", email: "jones@gmail.com")

    visit root_path

    within(".sign-in") do
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"

      click_on "Sign in"
    end

    expect(current_path).to eq user_path(user.id)
  end

  scenario "user sees error" do

    visit root_path
    within(".sign-in") do
      fill_in "Username", with: "frank"
      fill_in "Password", with: "123"
    end

    click_on "Sign in"
    expect(page).to have_content "Invalid credentials"
    expect(current_path).to eq root_path
  end
end
