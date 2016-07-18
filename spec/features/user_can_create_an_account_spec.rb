require "rails_helper"

RSpec.feature "user can create an account" do
  scenario "user is sent to game room" do
    visit root_path

    click_on "Create Account"
    within(".create-account") do
      fill_in "Email", with: "jones@gmail.com"
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"
      click_on "Create Account"
    end

    expect(current_path).to eq rooms_path
  end
end
