class RoomsController < ApplicationController
  def show
    if current_user
      @messages = Message.all
      @game = join_or_create_game
      # @players = @game.find_players
      @game_cards = Card.where(id: @game.game_cards)
      @cards = current_user.cards
    else
      render file: "/public/404.html"
    end
  end

  def join_or_create_game
    Game.last && !Game.last.started ? Game.last : Game.create
  end
end
