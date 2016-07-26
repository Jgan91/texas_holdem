# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    if ActionCable.server.connections.none?(&:current_user)
      Message.destroy_all
      Game.delete(Game.first) if Game.count > 500
    end
  end

  def speak(data)
    client_action = data["message"]
    return Message.create! content: "#{current_user.username}: #{client_action["chat"]}" if client_action["chat"]
    @game = Game.find_by(started: false) || Game.last # this should get replaced by a single game marked by id

    current_user.user_action(client_action["user_action"]) if client_action["user_action"]

    if client_action["join"] || client_action["add-ai-player"]
      player = client_action["add-ai-player"] || current_user
      @game.add_player(player)
      # start_game(@game) if ActionCable.server.connections.map(&:current_user)
      #   .count == @game.users.count
    elsif client_action["start-game"]
      start_game(@game)
    elsif @game.started
      game_play(@game)
    end
  end

  private

    def update_pot
      ActionCable.server.broadcast "room_channel", pot: "Pot: $" + Game.last.pot.to_s
    end

    def game_play(game)
      action = game.game_action
      # if action == Game... reset game properties on dom
      # sleep 0.3 if action.class == Game
      update_players(game) #pass the updated game in
      game_play(game) if action.class == Message
      if action.class == User
        Message.create! content: "#{action.username}'s turn"
        sleep 0.07
        ActionCable.server.broadcast "room_channel", turn: "#{action.id}"
      end
      update_pot
    end

    def start_game(game)
      game.update(started: true)
      game.set_up_game

      update_players(game)
      ActionCable.server.broadcast "room_channel", start_game: "start_game"
      Message.create! content: "THE GAME HAS STARTED!"
      
      game_play(game)
    end

    def update_players(game)
      RenderPlayerJob.perform_later game
    end
end
