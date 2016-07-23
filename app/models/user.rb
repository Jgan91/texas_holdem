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
    game.update(pot: game.pot + amount.to_i)
  end

  def fold
    update(action: 2)
  end

  def user_action(action)
    if action == "call"
      call_amount = highest_bet - user.total_bet
      bet(call_amount)
    elsif action["bet"]
      # return "Error" if check_bet(amount[:current_bet])
      # update(raise_count: raise_count + 1)
      # call_amount = Game.find(id).highest_bet - Game.find(id).users.last.total_bet
      # user.bet(amount[:current_bet].to_i + call_amount)
      bet(action["bet"].to_i)
      return Message.create! content: "#{username}: Bet $#{action["bet"]}"
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
    # Message.create! content: "#{username}'s turn"
    self
  end
end
