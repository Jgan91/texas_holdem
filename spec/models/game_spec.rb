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
end
