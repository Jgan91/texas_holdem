module PlayerHelper
  # def bet(player, amount)
  #   amount = player.cash if amount > player.cash
  #   # update(current_bet: amount)
  #   if player.class == User
  #     player.update(total_bet: (Game.find(game.id).users.find(player.id).total_bet + amount.to_i))
  #   end
  #   new_amount = player.cash - amount.to_i
  #   player.update(cash: new_amount)
  #   current_game = Game.find(game.id)
  #   current_game.update(pot: (current_game.pot + amount.to_i))
  # end
end
