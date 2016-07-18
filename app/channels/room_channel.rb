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
    client_action = data["message"]
    binding.pry
    if client_action == "ai_player" ||
      client_action == "little_blind" ||
      client_action == "big_blind"
      # do something with the pregame
    else
      Message.create! content: "#{current_user.username}: #{client_action}"
      # some sort of game action with the current user
    end
  end
end
