class AiPlayer < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username
  belongs_to :game, required: false
  has_many :cards
  include PlayerHelper
  include CardHelper

  def take_action
    Game.find(game.id).ai_players.find(self.id).update(action: 1)
    risk_factor = rand(1..10)
    sleep 1
    if bet_style == "conservative"
      bet_conservative(risk_factor)
    else
      bet_aggressive(risk_factor)
    end
  end

  def bet_conservative(risk_factor)
    return all_in if risk_factor == 10 && hand > 6 && !game.stage == "blinds" && game.stage
    if call_amount(self) > 0 && hand < 1
      risk_factor > 8 ? fold(self) : normal_bet
      risk_factor > 2 ? fold(self) : normal_bet
    elsif call_amount(self) > 0 && hand > 4
      risk_factor > 6 ? raise(call_amount(self) * 2) : normal_bet
    elsif call_amount(self) == 0 && hand > 3
      risk_factor > 5 ? raise(risk_factor * 50) : normal_bet
    else
      normal_bet
    end
  end

  def hand
    analyze = CardAnalyzer.new
    if game.stage == "blinds" || game.stage.nil?
      evaluate_pocket
    else
      hand = cards + Card.find(game.game_cards)
      9 - analyze.index_hand(hand)
    end
  end

  def evaluate_pocket
    if cards.all? { |card| card.value == 2 || card.value == 7 }
      3
    elsif CardAnalyzer.new.index_hand(cards) == 8
      6
    elsif card_converter(cards).map(&:value).any? { |value| value.to_i > 10 }
      5
    else
      4
    end
  end

  def bet_aggressive(risk_factor)
    return all_in if risk_factor > 7 && hand > 5 && !game.stage == "blinds" && game.stage
    if game.highest_bet > total_bet && hand < 1
      risk_factor > 5 ? fold(self) : normal_bet
    elsif game.highest_bet > total_bet && hand > 2
      risk_factor > 5 ? raise((game.highest_bet - total_bet) + game.little_blind) : normal_bet
    elsif game.highest_bet == total_bet && hand > 1
      risk_factor > 4 ? raise(game.little_blind) : normal_bet
    else
      normal_bet
    end
  end

  def normal_bet
    return call if call_amount(self) > 0
    check
  end

  def call
    return all_in if call_amount(self) >= cash
    bet(self, call_amount(self))
    Message.create! content: "#{username}: Call"
  end

  def check
    Message.create! content: "#{username}: Check"
  end

  def raise(amount)
    return all_in if amount >= cash
    return normal_bet if game.raise_count == 3
    game.update(raise_count: (game.raise_count + 1))
    bet(self, call_amount(self) + amount)
    update_actions(self)
    Message.create! content: "#{username}: Raise $#{amount}"
  end

  def all_in
    remaining_cash = cash
    bet(self, cash)
    update_actions(self) if remaining_cash > game.highest_bet
    Message.create! content: "#{username}: All In ($#{remaining_cash})!"
  end
end
