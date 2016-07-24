require 'rails_helper'

RSpec.describe Game, type: :model do
  it "has many ai players" do
    game = Game.create
    ai_player = AiPlayer.create(username: "AI")
    game.ai_players << ai_player
    expect(game.ai_players).to eq [ai_player]
  end

  it "has many users" do
    game = Game.create
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    game.users << user
    expect(game.users).to eq [user]
  end

  it "has many ai_players" do
    game = Game.create
    ai_player = AiPlayer.create(username: "ai")
    game.ai_players << ai_player
    expect(game.ai_players).to eq [ai_player]
  end

  it "has many cards" do
    game = Game.create
    card = Card.create(value: "King", suit: "hearts")
    game.cards << card
    expect(game.cards).to eq [card]
  end

  it "reveals all players" do
    game = Game.create
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    ai_player = AiPlayer.create(username: "AI")
    game.users << user
    game.ai_players << ai_player
    expect(game.players).to eq [user, ai_player]
  end

  it "loads a deck of 52 cards" do
    game = Game.create
    game.load_deck
    expect(Game.last.cards.count).to eq 52
    expect(Game.last.cards.sample.class).to eq Card
  end

  it "sets up the blinds" do
    game = Game.create
    user = game.users.create(username: "jones", password: "123", email: "j@gmail.com", cash: 1000)
    ai_player = game.ai_players.create(username: "bill")
    game.update(ordered_players: [user.id, "a" + ai_player.id.to_s])
    Game.last.set_blinds
    expect(User.last.cash).to eq 950
    expect(AiPlayer.last.cash).to eq 900
    expect(Game.last.pot).to eq 150
  end

  it "deals 2 cards to every player" do
    game = Game.create
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    ai_player = AiPlayer.create(username: "bill")
    game.update(ordered_players: [user.id, "a" + ai_player.id.to_s])
    expect(Game.last.find_players.count).to eq 2
    game.load_deck
    game.deal_pocket_cards
    expect(Game.last.cards.count).to eq 48
    expect(User.last.cards.count).to eq 2
    expect(AiPlayer.last.cards.count).to eq 2
  end

  it "selects the third player to take an action in beginning of game" do
    game = Game.create
    jones = game.users.create(username: "jones", password: "123", email: "j@gmail.com")
    jim = game.users.create(username: "jim", password: "123", email: "jim@gmail.com")
    bob = game.users.create(username: "bob", password: "123", email: "bob@gmail.com")
    game.update(ordered_players: [jones.id, jim.id, bob.id])
    game.set_blinds
    expect(game.game_action).to eq bob
  end

  it "can deal based on stage" do
    game = Game.create(stage: "flop")
    game.load_deck
    expect(Game.find(game.id).cards.count).to eq 52
    expect(Game.find(game.id).game_cards).to eq []
    Game.find(game.id).deal
    expect(Game.find(game.id).game_cards.count).to eq 1
    expect(Game.find(game.id).cards.count).to eq 50

    Game.find(game.id).update(stage: "blinds", game_cards: [])
    Game.find(game.id).deal
    expect(Game.find(game.id).game_cards.count).to eq 3
    expect(Game.find(game.id).cards.count).to eq 46
  end

  it "deals unique cards" do
    game = Game.create
    game.load_deck
    game.deal
    card = Game.find(game.id).game_cards.first
    expect(Game.last.cards.include?(card)).to eq false
  end

  it "updates the stage of the game" do
    game1 = Game.create(stage: "turn")
    game1.update_stage
    expect(Game.find(game1.id).stage).to eq "river"
    game2 = Game.create(stage: "flop")
    game2.update_stage
    expect(Game.find(game2.id).stage).to eq "turn"
    game3 = Game.create(stage: "blinds")
    game3.update_stage
    expect(Game.find(game3.id).stage).to eq "flop"
  end

  it "finds all the players in order" do
    game = Game.create
    user1 = game.users.create(username: "jones", password: "123", email: "j@gmail")
    user2 = game.users.create(username: "bob", password: "123", email: "abc@gmail")
    user3 = game.users.create(username: "jim", password: "123", email: "jim@gmail")
    game.update(ordered_players: [user2.id, user3.id, user1.id])
    expect(Game.find(game.id).find_players).to eq [user2, user3, user1]
  end

  it "finds the player with the highest bet" do
    game = Game.create
    user1 = game.users.create(username: "jones", password: "123", email: "j@gmail", total_bet: 150)
    user2 = game.users.create(username: "bob", password: "123", email: "b@gmail", total_bet: 200)
    ai_player = game.ai_players.create(username: "ai", total_bet: 100)
    game.update(ordered_players: [user1.id, user2.id, "a" + ai_player.id.to_s])
    expect(Game.find(game.id).highest_bet).to eq 200
  end
end
