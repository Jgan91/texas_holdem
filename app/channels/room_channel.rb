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
    @game = Game.find_by(started: false) || Game.last # this should get replaced by a single game marked by id
    message = ""
    if client_action["join"]
      @game.users << current_user.reset
      #potentially have a method called add players
      # ActionCable.server.broadcast "room_channel", player: render_player(current_user)
      Message.create! content: "#{current_user.username}: has joined the game"
      # message = "#{current_user.username}: has joined the game"
      # append user and cash to "players"
      if ActionCable.server.connections.map(&:current_user).count == @game.users.count

        @game.update(started: true)
        @game.set_up_game
        @game.find_players.each do |player|
          ActionCable.server.broadcast "room_channel", player: render_player(player)
        end

        # Message.create! content: "THE GAME HAS STARTED!"
        Message.create! content: "THE GAME HAS STARTED!"

        action = @game.game_action
        if action.class == User
          #append buttons to the current user by rendering a partial
          #highlight that user's name etc
          message = "#{action.username}'s turn"
        else
          message = action
        end
      end
    elsif client_action["add-ai-player"]
      ai_player = AiPlayer.order("random()").limit(1).reset.last
      @game.ai_players << ai_player
      # ActionCable.server.broadcast "room_channel", player: render_player(ai_player)
      # Message.create! content: "#{ai_player.username}: has joined the game"
      message = "#{ai_player.username}: has joined the game"
    elsif @game.started
      action = @game.game_action
      if action.class == User
        #append buttons to the current user by rendering a partial
        #highlight that user's name etc
        message = "#{action.user_name}'s turn"
      else
        message = action
      end
      ActionCable.server.broadcast "room_channel", pot: "Pot: $" + Game.last.pot.to_s
    else
      # Message.create! content: "#{current_user.username}: #{client_action}"
      message = "#{current_user.username}: #{client_action}"
      # some sort of game action with the current user
    end
    Message.create! content: message
  end

  private
    def render_player(player)
      ApplicationController.renderer.render(partial: "players/player", locals: { player: player})
    end
end
