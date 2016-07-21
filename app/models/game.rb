class Game < ApplicationRecord
  has_many :ai_players
  has_many :users
  has_many :cards

  def players
    users + ai_players
  end

  def set_up_game
    Message.destroy_all
    update(ordered_players: players.shuffle.map do |player|
      player.class == AiPlayer ? "a" + player.id.to_s : player.id.to_s
    end)
    set_blinds
    load_deck
    deal_pocket_cards
  end

  def set_blinds
    find_players[0].bet(little_blind)
    find_players[1].bet(big_blind)
  end

  def load_deck
    deck = CardsService.new.deck_of_cards_hash.map do |card|
      Card.find_or_create_by(value: card[:value], suit: card[:suit], image: card[:image])
    end
    self.cards = deck
  end

  def deal_pocket_cards
    find_players.each do |player|
      2.times { player.cards << cards.delete(cards.order("random()").limit(1)) }
    end
  end

  def find_players
    ordered_players.map do |id|
      id.include?("a") ? AiPlayer.find(id[1..-1]) : User.find(id)
    end
  end
end
