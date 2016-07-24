class User < ApplicationRecord
  has_secure_password

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email

  belongs_to :game, required: false
  has_many :cards

  def bet(amount)
    amount = cash if amount > cash
    # update(current_bet: amount)
    update(total_bet: total_bet + amount.to_i)
    new_amount = cash - amount.to_i
    update(cash: new_amount)
    current_game = Game.find(game.id)
    current_game.update(pot: (current_game.pot + amount.to_i))
  end

  def fold
    update(action: 2)
    update(total_bet: 0)
  end

  def call
    call_amount = Game.find(game.id).highest_bet - total_bet
    Message.create! content: "#{username}: Call"
    bet(call_amount)
  end

  def user_action(action)
    if action == "check"
      return call if Game.find(game.id).highest_bet > total_bet
    elsif action["bet"]
      amount = action["bet"].to_i
      return error(amount) if amount < game.little_blind || amount > cash
      # update(raise_count: raise_count + 1)
      # call_amount = Game.find(id).highest_bet - Game.find(id).users.last.total_bet
      # user.bet(amount[:current_bet].to_i + call_amount)
      # game.find_players.reject { |player| player == self }
      #   .each { |player| player.update(action: (player.action -1)) }
      bet(amount)
      game.find_players.each do |player|
        action_count = player.action
        player.update(action: (action_count - 1))
      end

      # return Message.create! content: "#{username}: Bet $#{amount}"
      action = "Bet $ #{amount}"
    elsif action == "fold"
      fold
    end
    Message.create! content: "#{username}: #{action}"
  end

  def reset
    cards.delete_all
    update(total_bet: 0)
    update(action: 0)
    self
  end

  def take_action
    update(action: 1)
    self
  end

  private
    def error(amount)
      game.users.find(self.id).update(action: 0)
      Message.create! content: "You cannot bet more than you have or less than the little blind."
      self
    end
end
