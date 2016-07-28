module PlayerHelper
  def bet(player, amount)
    amount = player.cash if amount > player.cash
    # update(current_bet: amount)
    # if player.class == User
    #   player.update(total_bet: (Game.find(player.game.id).users.find(player.id).total_bet + amount.to_i))
    # end
    raise_amount = amount.to_i + call_amount(player)
    player.update(total_bet:
      (Game.find(player.game.id).find_players.detect do |game_player|
        game_player == player
      end.total_bet + raise_amount))
    new_amount = player.cash - raise_amount
    player.update(cash: new_amount)
    current_game = Game.find(player.game.id)
    current_game.update(pot: (current_game.pot + raise_amount))
  end

  def update_actions(current_player)
    Game.find(game.id).find_players.reject { |player| player == current_player || player.action == 2 }
      .each do |player|
      action_count = player.action
      player.update(action: (action_count - 1))
    end
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

  def fold(player)
    Game.find(player.game.id).find_players.detect do |game_player|
      game_player == player
    end.update(action: 2, total_bet: 0)
    Message.create! content: "#{username}: Fold" if player.class == AiPlayer
  end

  def take_pot(player)
    game = Game.find(player.game.id)
    pot = game.pot
    game.find_players.detect { |current_player| current_player == player }
      .update(cash: (player.cash + pot))
  end
end
