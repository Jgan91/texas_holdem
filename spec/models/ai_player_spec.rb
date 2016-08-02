require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it "should validate the presence of username" do
    expect(AiPlayer.create(username: "frank")).to be_valid
  end

  it "should belong to a game" do
    ai_player = AiPlayer.create(username: "frank")
    game = Game.create
    game.ai_players << ai_player
    expect(ai_player.game).to eq game
  end

  it "has many cards" do
    ai_player = AiPlayer.create(username: "frank")
    card = Card.create(suit: "hearts", value: "7")
    ai_player.cards << card
    expect(ai_player.cards).to eq [card]
  end

  it "can bet" do
    game = Game.create
    ai = game.ai_players.create(username: "ai")
    game.update(ordered_players: ["a" + ai.id.to_s])
    expect(ai.total_bet).to eq 0
    expect(ai.cash).to eq 1000
    game.ai_players.find(ai.id).bet(ai, 200)
    expect(game.ai_players.find(ai.id).total_bet).to eq 200
    expect(game.ai_players.find(ai.id).cash).to eq 800
  end

  it "resets the ai player's cards and bets" do
    game = Game.create(little_blind: 30, big_blind: 60)
    card = Card.create(suit: "Hearts", value: "8")
    ai_player = game.ai_players.create(username: "ai",
                            cash: 1100,
                            total_bet: 400,
                            action: 1
                            )
    ai_player.cards << card
    expect(AiPlayer.last.cards.count).to eq 1
    expect(AiPlayer.last.total_bet).to eq 400
    expect(AiPlayer.last.action).to eq 1

    ai_player.reset(ai_player)
    expect(AiPlayer.last.username).to eq "ai"
    expect(AiPlayer.last.cards.count).to eq 0
    expect(AiPlayer.last.total_bet).to eq 0
    expect(AiPlayer.last.action).to eq 0
    expect(AiPlayer.last.cash).to eq 1100
  end
end
