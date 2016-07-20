require "rails_helper"

RSpec.feature "user can logout" do
  xscenario "user sees root" do
    User.create(username: "jones", password: "password", email: "j@gmail.com")

    visit root_path

    expect(page).not_to have_content "Sign Out"


    within(".sign-in") do
      fill_in "Username", with: "jones"
      fill_in "Password", with: "123"

      click_on "Sign in"
    end

    expect(page).to have_content "Signed in as jones"
    expect(current_path).to eq user_path(User.last.id)

    expect(page).not_to have_content "Sign In"
    expect(page).not_to have_content "Create Account"

    click_on "Sign Out"

    expect(page).not_to have_content "Signed in as jones"
    expect(page).to have_content "Sign In"
    expect(page).to have_content "Create Account"
  end
end
