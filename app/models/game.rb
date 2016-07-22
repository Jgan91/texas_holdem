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
    find_players[0..1].each do |player|
      player.update(action: 1)
    end
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

  def game_action
    # find first player who's action is lowest (0) and who hasn't folded
    # if all players have taken an action or folded --> deal
    #when all players have equal actions > than 0 -->
      # if blinds --> deal flop
      # if flop --> deal turn
      # if turn --> deal river
      # if river --> display winner
    #when a player raises, all other player actions decrement
    return deal if find_players.all? { |player| player.action >= 1}
    if stage == "blinds"
      all_players = find_players[1..-1] + find_players[0..1]
      # find_players[2 % players.length].take_action
      all_players.min_by(&:action).take_action
    # elsif flop
    # elsif turn
    # elsif river
    elsif winner
      # show winner
    else
      find_players.min_by(&:action).take_action
    end
  end

  def deal
    cards.pop
    if game.stage == "blinds"
      update(stage: "flop")
      deal_flop
    elsif game.stage == "flop"
      update(stage: "turn")
      deal_single_card
    else game.stage == "turn"
      update(stage: "river")
      deal_single_card
    end
  end

  def deal_flop
    3.times do
      deal_single_card
    end
  end

  def deal_single_card
    game_cards << cards.limit(1).pluck(:id)
  end
end
