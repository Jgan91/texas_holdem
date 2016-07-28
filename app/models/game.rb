class Game < ApplicationRecord
  has_many :ai_players
  has_many :users
  has_many :cards
  include PlayerHelper

  def players
    users + ai_players
  end

  def add_player(player)
    if player.is_a? User
      users << reset(player)
    else
      player = add_ai_player
      ai_players << player
    end
    Message.create! content: "#{player.username}: has joined the game"
  end

  def add_ai_player
    player = reset(AiPlayer.order("random()").last)
    add_ai_player if players.include?(player)
    player
  end

  def set_up_game
    Message.destroy_all
    find_order
    set_blinds
    load_deck
    deal_pocket_cards
  end

  def find_order
    if ordered_players == []
      new_order = players.shuffle.map do |player|
        player.class == AiPlayer ? "a" + player.id.to_s : player.id.to_s
      end
    else
      new_order = ordered_players.reject { |id| id.sub("a", "") == zero_cash }.rotate(-1)
      new_order = new_order.rotate(-1) if new_order[1] == ordered_players[1]
    end
    update(ordered_players: new_order)
  end

  def zero_cash
    players.detect { |player| player.cash == 0 }.id.to_s
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
    deal if players_updated?
    all_players = find_players

    all_players = find_players[2..-1] + find_players[0..1] if stage == "blinds"
    all_players.reject { |player| player.action == 2 }.min_by(&:action).take_action
  end

  def players_updated?
    find_players.all? { |player| player.action >= 1}
  end

  def deal
    cards.last.destroy
    stage == "blinds" ? deal_flop : deal_single_card
    update_stage
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
    update(stage: "river") if stage == "turn"
    update(stage: "turn") if stage == "flop"
    update(stage: "flop") if stage == "blinds"
    find_players.each { |player| player.update(action: 0) if player.action < 2 }
  end

  def highest_bet
    find_players.max_by(&:total_bet).total_bet
  end

  def declare_winner(winner = find_winner)
    take_pot(winner)
    return Message.create! content: "#{winner.username} WINS!" if players.one? { |player| player.action != 2 }
    hand = CardAnalyzer.new.find_hand(winner.cards).class.to_s.underscore.humanize
    Message.create! content: "#{winner.username} WINS with a #{hand}!"
  end

  def find_winner
    players = find_players.select { |player| player.action < 2 }
      players.each do |player|
        player.cards += game_cards.map { |id| Card.find(id) }
      end
    CardAnalyzer.new.determine_winner(players)
  end

  def reset_game
    update(pot: 0, stage: "blinds", game_cards: [])
    players.each { |player| reset(player) }
    self
  end
end
