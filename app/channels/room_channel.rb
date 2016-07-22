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
    if client_action["join"]
      @game.users << current_user.reset
      Message.create! content: "#{current_user.username}: has joined the game"
      start_game(@game) if ActionCable.server.connections.map(&:current_user)
        .count == @game.users.count
    elsif client_action["add-ai-player"]
      ai_player = AiPlayer.order("random()").limit(1).reset.last
      @game.ai_players << ai_player
      message = "#{ai_player.username}: has joined the game"
    elsif @game.started
      game_play(@game)
    else
      message = "#{current_user.username}: #{client_action}"
    end
    Message.create! content: message
  end

  private
    def render_player(player)
      ApplicationController.renderer.render(partial: "players/player", locals: { player: player})
    end

    def game_play(game)
      action = game.game_action
      if action.class == User
        Message.create! content: "#{action.username}'s turn"
      else
        Message.create! content: action
      end
      ActionCable.server.broadcast "room_channel", pot: "Pot: $" + Game.last.pot.to_s
    end

    def start_game(game)
      @game.update(started: true)
      @game.set_up_game
      @game.find_players.each do |player|
        ActionCable.server.broadcast "room_channel", player: render_player(player)
      end
      Message.create! content: "THE GAME HAS STARTED!"
      player = @game.find_players[2 % @game.players.length].take_action
      Message.create! content: "#{player.username}'s turn'"
    end
end
