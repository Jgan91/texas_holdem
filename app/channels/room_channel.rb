# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    if ActionCable.server.connections.none?(&:current_user)
      Game.destroy_all
    end
  end

  def speak(data)
    # ActionCable.server.broadcast "room_channel", message: data["message"]
    #have access to current user here
    # binding.pry
    client_action = data["message"]
    @game = Game.find_by(started: false)
    if client_action["join"]
      @game.users << current_user.reset
      Message.create! content: "#{current_user.username}: has joined the game"
    elsif client_action["add-ai-player"]
      ai_player = AiPlayer.order("random()").limit(1).reset.last
      @game.ai_players << ai_player
      Message.create! content: "#{ai_player.username}: has joined the game"
    elsif client_action["startGame"]
      @game.update(started: true)
      # players = ActionCable.server.connections.map { |connection| connection.current_user.reset }
      # game.users = players
      @game.set_up_game
      # flash[:ai_action] = game.ai_action
      # start the game with the relevent stats
    else
      Message.create! content: "#{current_user.username}: #{client_action}"
      # some sort of game action with the current user
    end
  end
end
