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
      return error(amount) if amount < game.little_blind || amount > Game.find(game.id).users.find(id).cash
      bet(self, amount + call_amount(self))
      update_actions(self)
      game.update(raise_count: (game.raise_count + 1))
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

  def remove_from_game
    if game
      user_action("fold")
      game.users.delete(self)
      game_id = nil
    end
  end

  private
    def error(amount)
      game.users.find(self.id).update(action: 0)
      Message.create! content: "You cannot bet more than you have or less than the little blind."
      self
    end
end
