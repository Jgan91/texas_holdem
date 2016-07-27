class RoomsController < ApplicationController
  def show
    if current_user
      @messages = Message.all
      @game = Game.last || Game.create
      # @players = @game.find_players
      @game_cards = Card.where(id: @game.game_cards)
      @cards = current_user.cards
    else
      render file: "/public/404.html"
    end
  end
end
