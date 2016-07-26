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
    return reset_game if stage == "winner"
    deal if find_players.all? { |player| player.action >= 1}
    all_players = find_players

    all_players = find_players[2..-1] + find_players[0..1] if stage == "blinds"
    all_players.reject { |player| player.action == 2 }.min_by(&:action).take_action
  end

  def deal
    cards.last.destroy
    if stage == "blinds"
      deal_flop
    else
      deal_single_card
    end
    update_stage
    # find_players.each { |player| player.update(action: 0) if player.action < 2}
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
    return declare_winner if stage == "river"
    update(stage: "river") if stage == "turn"
    update(stage: "turn") if stage == "flop"
    update(stage: "flop") if stage == "blinds"
    find_players.each { |player| player.update(action: 0) if player.action < 2 }
  end

  def highest_bet
    find_players.max_by(&:total_bet).total_bet
  end

  def declare_winner
    players = find_players.select { |player| player.action < 2 }
      players.each do |player|
        player.cards += game_cards.map { |id| Card.find(id) }
      end
    winner = CardAnalyzer.new.determine_winner(players)
    hand = CardAnalyzer.new.find_hand(winner.cards).class.to_s.underscore.humanize

    take_pot(winner)
    Message.create! content: "#{winner.username} WINS with a #{hand}!"
    update(stage: "winner")
  end

  def reset_game
    update(ordered_players: (ordered_players.rotate(-1)),
            pot: 0,
            stage: "blinds",
            game_cards: [])
    players.each { |player| reset(player) }
    self
  end
end
