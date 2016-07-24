require 'rails_helper'

RSpec.describe User, type: :model do
  it "should validate the presence of username, email, and password" do
    expect(User.create(email: "a@gmail.com", password: "123")).not_to be_valid
    expect(User.create(username: "bob", password: "123")).not_to be_valid
    expect(User.create(email: "a@gmail.com", username: "frank")).not_to be_valid

    expect(User.create(email: "a@gmail.com", username: "frank", password: "123")).to be_valid
  end

  it "should belong to a game" do
    user = User.create(username: "frank", password: "123", email: "j@gmail.com")
    game = Game.create
    game.users << user
    expect(user.game).to eq game
  end

  it "has many cards" do
    user = User.create(username: "frank", password: "123", email: "j@gmail.com")
    card = Card.create(suit: "hearts", value: "7")
    user.cards << card
    expect(user.cards).to eq [card]
  end

  it "can bet" do
    game = Game.create
    user = game.users.create(username: "jones", password: "password", email: "j@gmail.com")
    expect(user.total_bet).to eq 0
    expect(user.cash).to eq 2000
    user.bet(50)
    expect(user.total_bet).to eq 50
    expect(user.cash).to eq 1950
    expect(game.pot).to eq 50
  end

  it "resets the player's cards, actions, and bets" do
    game = Game.create(little_blind: 30, big_blind: 60)
    card = Card.create(suit: "Hearts", value: "8")
    user = game.users.create(username: "jones",
                            password: "password",
                            email: "j@gmail.com",
                            cash: 1100,
                            total_bet: 400,
                            action: 1
                            )
    user.cards << card
    expect(User.last.cards.count).to eq 1
    expect(User.last.total_bet).to eq 400
    expect(User.last.action).to eq 1

    user.reset
    expect(User.last.username).to eq "jones"
    expect(User.last.cards.count).to eq 0
    expect(User.last.total_bet).to eq 0
    expect(User.last.action).to eq 0
    expect(User.last.cash).to eq 1100
  end

  it "can take an action" do
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    expect(user.action).to eq 0
    expect(user.take_action).to eq user
  end

  it "can fold" do
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    expect(user.action).to eq 0
    user.fold
    expect(User.find(user.id).action).to eq 2
  end

  it "can call" do
    game = Game.create
    user = game.users.create(username: "jones",
                             password: "123",
                             email: "j@gmail.com",
                             total_bet: 100,
                             cash: 1000)
    user2 = game.users.create(username: "bob",
                              password: "123",
                              email: "b@gmail.com",
                              total_bet: 200,
                              cash: 1000)
    game.update(ordered_players: [user.id, user2.id])
    expect(User.pluck(:cash)).to eq [1000, 1000]
    user.call
    expect(user.cash).to eq 900
  end

  it "makes an action" do
    game = Game.create
    user = game.users.create(username: "jones",
                             password: "123",
                             email: "j@gmail.com",
                             total_bet: 100,
                             cash: 1000)
    user2 = game.users.create(username: "bob",
                              password: "123",
                              email: "b@gmail.com",
                              total_bet: 100,
                              cash: 1000)
    game.update(ordered_players: [user.id, user2.id])
    expect(User.pluck(:cash)).to eq [1000, 1000]
    user.user_action("check")
    expect(user.cash).to eq 1000
  end

  it "will not update the user action if bet is invalid" do
    game = Game.create(little_blind: 50)
    user = game.users.create(username: "jones",
                             password: "123",
                             email: "j@gmail.com",
                             total_bet: 100,
                             cash: 1000)
    game.update(ordered_players: [user.id])

    error_message = "You cannot bet more than you have or less than the little blind."

    user.user_action("bet" => "40")
    expect(Message.last.content).to eq error_message
    user = User.find(user.id)
    expect(user.cash).to eq 1000

    user.user_action("bet" => "1150")
    expect(Message.last.content).to eq error_message
    user = User.find(user.id)
    expect(user.cash).to eq 1000
  end
end
