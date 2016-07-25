class Game < ApplicationRecord
  has_many :ai_players
  has_many :users
  has_many :cards
  include PlayerHelper

  def players
    users + ai_players
  end

  def add_player(player)
    if player.class == User
      users << reset(player)
    else
      player = reset(AiPlayer.order("random()").last)
      ai_players << player
    end
    Message.create! content: "#{player.username}: has joined the game"
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
    bet(find_players[0], little_blind)
    bet(find_players[1], big_blind)
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
    deal if find_players.all? { |player| player.action >= 1}
    if stage == "blinds"
      all_players = find_players[2..-1] + find_players[0..1]
      # find_players[2 % players.length].take_action
      all_players.min_by(&:action).take_action
    # elsif flop
    # elsif turn
    # elsif river
    # elsif winner
      # show winner
    else
      find_players.min_by(&:action).take_action
    end
  end

  def deal
    cards.last.destroy
    if stage == "blinds"
      deal_flop
    else
      deal_single_card
    end
    update_stage
    find_players.each { |player| player.update(action: 0) if player.action == 1}
    Message.create! content: "#{stage.upcase}"
  end

  def deal_flop
    3.times do
      deal_single_card
    end
  end

  def deal_single_card
    card = self.cards.delete(Card.find(self.cards.first.id)).last
    GameCardJob.perform_later card
    game_cards << card.id
  end

  def update_stage
    if stage == "blinds"
      update(stage: "flop")
    elsif stage == "flop"
      update(stage: "turn")
    elsif stage == "turn"
      update(stage: "river")
    end
    find_players.reject { |player| player.action == 2 }
      .each { |player| player.update(action: 0) }
  end

  def highest_bet
    find_players.max_by(&:total_bet).total_bet
  end
end
