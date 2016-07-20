class RoomsController < ApplicationController
  def show
    if current_user
      @messages = Message.all
      @game = Game.create
      # @game.users << current_user
    else
      render file: "/public/404.html"
    end
  end
end
