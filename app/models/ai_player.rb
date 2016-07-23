class AiPlayer < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username
  belongs_to :game, required: false
  has_many :cards

  def bet(amount)
    amount = cash if amount.to_i > cash
    # update(current_bet: amount.to_i)
    update(total_bet: total_bet + amount)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    game.update(pot: game.pot + amount.to_i)
  end

  def reset
    cards.delete_all
    update(total_bet: 0)
    update(action: 0)
    self
  end

  def take_action
    update(action: 1)
    risk_factor = rand(1..10)

    if bet_style == "conservative"
      bet_conservative(risk_factor)
    elsif bet_style == "aggressive"
      bet_aggressive(risk_factor)
    else
      normal_bet
    end
  end

  def bet_conservative(risk_factor)
    # return all_in if risk_factor == 10 && hand > 6 && !game.flop_cards.empty?
    # if game.highest_bet > total_bet && hand < 1
    #   risk_factor > 2 ? fold : normal_bet
    # elsif game.highest_bet > total_bet && hand > 4
    #   risk_factor > 6 ? raise((game.highest_bet - total_bet) * 2) : normal_bet
    # elsif game.highest_bet == total_bet && hand > 3
    #   risk_factor > 5 ? raise((risk_factor * 50) + game.little_blind) : normal_bet
    # else
      normal_bet
    # end
  end

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
    # if game.highest_bet > total_bet
    #   call(game.highest_bet - total_bet)
    # else
      check
    # end
  end

  def fold
    update(action: 2)
    # still_playing = game.find_players.reject { |player| player.folded || player.out }
    # if still_playing.count == 1
    #   winner = still_playing.last
    #   winner.take_winnings
    #   game.update(winner: "#{winner.id} #{winner.class}".downcase)
    # end
    Message.create! content: "#{username}: Fold"
  end

  def call(amount)
    return all_in if amount >= cash
    bet(amount)
    Message.create! content: "#{username}: Call"
  end

  def check
    Message.create! content: "#{username}: Check"
  end

  def raise(amount)
    return all_in if amount >= cash
    # if game.raise_count == 3
    #   normal_bet
    # else
      call = game.highest_bet - total_bet
      bet(call + amount)
      # game.update(raise_count: game.raise_count + 1)
      Message.create! content: "#{username}: Raise $#{amount}"
    # end
  end

  def all_in
    # remaining_cash = cash
    Message.create! content: "#{username}: All In ($#{cash})!"
    bet(cash)
  end
end
