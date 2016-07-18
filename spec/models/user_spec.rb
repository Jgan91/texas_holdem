require 'rails_helper'

RSpec.describe User, type: :model do
  it "should validate the presence of username, email, and password" do
    expect(User.create(email: "a@gmail.com", password: "123")).not_to be_valid
    expect(User.create(username: "bob", password: "123")).not_to be_valid
    expect(User.create(email: "a@gmail.com", username: "frank")).not_to be_valid

    expect(User.create(email: "a@gmail.com", username: "frank", password: "123")).to be_valid
  end
end
