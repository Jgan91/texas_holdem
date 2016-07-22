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
    self
  end

  # def take_action
  #
  # end
end
