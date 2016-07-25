class AiPlayer < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username
  belongs_to :game, required: false
  has_many :cards
  include PlayerHelper

  # def bet(amount)
  #   amount = cash if amount.to_i > cash
  #   # update(current_bet: amount.to_i)
  #   update(total_bet: (Game.find(game.id).ai_players.find(self.id).total_bet + amount.to_i))
  #   new_amount = cash - amount.to_i
  #   update(cash: new_amount)
  #   game.update(pot: game.pot + amount.to_i)
  #   current_game = Game.find(game.id)
  #   current_game.update(pot: (current_game.pot + amount.to_i))
  # end

  # def reset
  #   cards.delete_all
  #   update(total_bet: 0, action: 0)
  #   self
  # end

  def take_action
    Game.find(game.id).ai_players.find(self.id).update(action: 1)
    risk_factor = rand(1..10)

    # if bet_style == "conservative"
      bet_conservative(risk_factor)
    # else
    #   bet_aggressive(risk_factor)
    # end
  end

  def bet_conservative(risk_factor)
    # return all_in if risk_factor == 10 && hand > 6 && !game.stage == "blinds"
    if call_amount(self) > 0 #&& hand < 1
      risk_factor > 2 ? fold(self) : normal_bet
    elsif call_amount(self) > 0 #&& hand > 4
      risk_factor > 6 ? raise(call_amount(self) * 2) : normal_bet
    elsif call_amount(self) == 0 #&& hand > 3
      risk_factor > 5 ? raise(risk_factor * 50) : normal_bet
    else
      normal_bet
    end
  end

  # def hand
  #   analyze = CardAnalyzer.new
  #   if game.flop_cards.empty?
  #     evaluate_pocket
  #   elsif game.turn_card.empty?
  #     hand = make_card_objects(cards + game.flop_cards)
  #     9 - analyze.index_hand(hand)
  #   elsif game.river_card.empty?
  #     hand = make_card_objects(cards + game.flop_cards + [game.turn_card])
  #     9 - analyze.index_hand(hand)
  #   else
  #     hand = make_card_objects(cards + game.flop_cards + [game.turn_card, game.river_card])
  #     9 - analyze.index_hand(hand)
  #   end
  # end

  # def evaluate_pocket
  #   current_hand = make_card_objects(cards)
  #   if current_hand.all? { |card| card.value == 2 || card.value == 7 }
  #     3
  #   elsif CardAnalyzer.new.index_hand(current_hand) == 8
  #     6
  #   elsif card_converter(current_hand).map(&:value).any? { |value| value > 10 }
  #     5
  #   else
  #     4
  #   end
  # end

  def bet_aggressive(risk_factor)
    # return all_in if risk_factor > 7 && hand > 5 && !game.flop_cards.empty?
    # if game.highest_bet > total_bet && hand < 1
    #   risk_factor > 5 ? fold : normal_bet
    # elsif game.highest_bet > total_bet && hand > 2
    #   risk_factor > 5 ? raise((game.highest_bet - total_bet) + game.little_blind) : normal_bet
    # elsif game.highest_bet == total_bet && hand > 1
    #   risk_factor > 4 ? raise(game.little_blind) : normal_bet
    # else
      normal_bet
    # end
  end

  def normal_bet
    return call if call_amount(self) > 0
    check
  end

  # def fold
  #   # still_playing = game.find_players.reject { |player| player.folded || player.out }
  #   # if still_playing.count == 1
  #   #   winner = still_playing.last
  #   #   winner.take_winnings
  #   #   game.update(winner: "#{winner.id} #{winner.class}".downcase)
  #   # end
  #   Game.find(game.id).ai_players.find(self.id).update(action: 2, total_bet: 0)
  #   Message.create! content: "#{username}: Fold"
  # end

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
    # return normal_bet if game.raise_count == 3

    bet(self, call_amount(self) + amount)
    update_actions(self)
    Message.create! content: "#{username}: Raise $#{amount}"
  end

  def all_in
    # remaining_cash = cash
    bet(self, cash)
    Message.create! content: "#{username}: All In ($#{cash})!"
  end
end
