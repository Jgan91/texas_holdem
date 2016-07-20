RSpec.describe Card, type: :model do
  it "should belong to a game" do
    card = Card.create(value: "King", suit: "Hearts")
    game = Game.create
    game.cards << card
    expect(card.game).to eq game
  end

  it "should belong to a game" do
    card = Card.create(value: "King", suit: "Hearts")
    ai_player = AiPlayer.create(username: "ai")
    ai_player.cards << card
    expect(card.ai_player).to eq ai_player
  end

  it "should belong to a game" do
    card = Card.create(value: "King", suit: "Hearts")
    user = User.create(username: "jones", password: "123", email: "j@gmail.com")
    user.cards << card
    expect(card.user).to eq user
  end
end
