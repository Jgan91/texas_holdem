module PlayerHelper
  def bet(player, amount)
    amount = player.cash if amount > player.cash
    # update(current_bet: amount)
    if player.class == User
      player.update(total_bet: (Game.find(player.game.id).users.find(player.id).total_bet + amount.to_i))
    end
    new_amount = player.cash - amount.to_i
    player.update(cash: new_amount)
    current_game = Game.find(player.game.id)
    current_game.update(pot: (current_game.pot + amount.to_i))
  end

  def reset(player)
    player.cards.delete_all
    player.update(total_bet: 0, action: 0)
    player
  end

  def call_amount(player)
    Game.find(player.game.id).highest_bet - Game.find(player.game.id).find_players.detect do |game_player|
      game_player == player
    end.total_bet
  end
end
