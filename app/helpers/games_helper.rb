module GamesHelper
  def display_players(game)
    if game.started
      game.find_players
    else
      game.players
    end
  end
end
