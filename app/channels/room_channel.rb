# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # ActionCable.server.broadcast "room_channel", message: data["message"]
    #have access to current user here
    # binding.pry
    client_action = data["message"]
    if client_action["gameInfo"]
      game = Game.create(little_blind: client_action["gameInfo"].first, big_blind: client_action["gameInfo"][1])
      ai_players = AiPlayer.limit(client_action["gameInfo"].last).map { |ai_player| ai_player.reset }
      game.ai_players = ai_players

      players = ActionCable.server.connections.map { |connection| connection.current_user.reset }
      game.users = players
      game.set_up_game
      # flash[:ai_action] = game.ai_action
      # start the game with the relevent stats
    else
      Message.create! content: "#{current_user.username}: #{client_action}"
      # some sort of game action with the current user
    end
  end
end
