require 'rails_helper'

RSpec.describe AiPlayer, type: :model do
  it "should validate the presence of username" do
    expect(AiPlayer.create).not_to be_valid
    expect(AiPlayer.create(username: "frank")).to be_valid
  end

  it "should belong to a game" do
    ai_player = AiPlayer.create(username: "frank")
    game = Game.create
    game.ai_players << ai_player
    expect(ai_player.game).to eq game
  end
end
