require "rails_helper"

RSpec.describe CardsService do
  it "returns a deck of 52 shuffled cards" do
    service = CardsService.new
    cards = service.deck_of_cards_hash
    expect(cards.count).to eq 52
    assert cards.last[:value]
    assert cards.first[:suit]
    assert cards[37][:image]
  end
end
