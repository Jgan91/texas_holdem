class RoomsController < ApplicationController
  def show
    if current_user
      @messages = Message.all
      @game = Game.last || Game.create
      #use a method to find a game by id
    else
      render file: "/public/404.html"
    end
  end
end
