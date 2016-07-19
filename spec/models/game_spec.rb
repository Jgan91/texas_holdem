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

  it "reveals all players" do
    game = Game.create
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    ai_player = AiPlayer.create(username: "AI")
    game.users << user
    game.ai_players << ai_player
    expect(game.players).to eq [user, ai_player]
  end
end
