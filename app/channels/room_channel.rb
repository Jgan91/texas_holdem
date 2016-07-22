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
    # return user_action()
    return Message.create! content: "#{current_user.username}: #{client_action["chat"]}" if client_action["chat"]
    @game = Game.find_by(started: false) || Game.last # this should get replaced by a single game marked by id

    current_user.user_action(client_action["user_action"]) if client_action["user_action"]

    if client_action["join"]
      @game.users << current_user.reset
      Message.create! content: "#{current_user.username}: has joined the game"
      start_game(@game) if ActionCable.server.connections.map(&:current_user)
        .count == @game.users.count
    elsif client_action["add-ai-player"]
      ai_player = AiPlayer.order("random()").limit(1).reset.last
      @game.ai_players << ai_player
      Message.create! content: "#{ai_player.username}: has joined the game"
    elsif @game.started
      game_play(@game)
    end
  end

  private

    def pot
      ActionCable.server.broadcast "room_channel", pot: "Pot: $" + Game.last.pot.to_s
    end

    def render_player(player)
      ApplicationController.renderer.render(partial: "players/player", locals: { player: player})
    end

    def game_play(game)
      action = game.game_action
      if action.class == User
        Message.create! content: "#{action.username}'s turn"
      # elsif action
      # else
        # Message.create! content: action
      end
      pot
      # append game cards to the dom if deal
    end

    # def render_game_cards(card)
    #   ApplicationController.renderer.render(partial: "cards/card", locals: { card: card})
    # end

    def start_game(game)
      @game.update(started: true)
      @game.set_up_game
      @game.find_players.each do |player|
        ActionCable.server.broadcast "room_channel", player: render_player(player)
      end
      Message.create! content: "THE GAME HAS STARTED!"
      player = @game.find_players[2 % @game.players.length].take_action
      Message.create! content: "#{player.username}'s turn'"
      pot
    end
end
