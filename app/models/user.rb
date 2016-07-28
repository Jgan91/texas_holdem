class User < ApplicationRecord
  include PlayerHelper
  has_secure_password

  validates_presence_of :username, :email
  validates_uniqueness_of :username, :email

  belongs_to :game, required: false
  has_many :cards

  def call
    Message.create! content: "#{username}: Call"
    bet(self, call_amount(self))
  end

  def user_action(action)
    if action == "check"
      return call if call_amount(self) > 0
    elsif action["bet"]
      amount = action["bet"].to_i
      return error(amount) if amount < game.little_blind || amount > cash
      # update(raise_count: raise_count + 1)
      # call_amount = Game.find(id).highest_bet - Game.find(id).users.last.total_bet
      # user.bet(amount[:current_bet].to_i + call_amount)
      # game.find_players.reject { |player| player == self }
      #   .each { |player| player.update(action: (player.action -1)) }
      bet(self, amount + call_amount(self))
      update_actions(self)

      # return Message.create! content: "#{username}: Bet $#{amount}"
      action = "Raise: $#{amount}"
    elsif action == "fold"
      fold(self)
    end
    Message.create! content: "#{username}: #{action}"
  end

  def take_action
    Game.find(game.id).users.find(self.id).update(action: 1)
    self
  end

  private
    def error(amount)
      game.users.find(self.id).update(action: 0)
      Message.create! content: "You cannot bet more than you have or less than the little blind."
      self
    end
end
