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
    @game = Game.find_by(started: false) || Game.find(current_user.game.id)

    current_user.user_action(client_action["user_action"]) if client_action["user_action"]

    if client_action["join"] || client_action["add-ai-player"]
      player = client_action["add-ai-player"] || current_user
      @game.add_player(player)
    elsif client_action["start-game"]
      start_game(@game)
    elsif @game.started
      @game = Game.find(@game.id)
      game_play(@game)
    end
  end

  private

    def broadcast(message)
      ActionCable.server.broadcast "room_channel", message
    end

    def update_pot
      broadcast pot: "Pot: $" + Game.last.pot.to_s
    end


    def game_play(game)
      return declare_champion(game) if champion?(game)
      reset_table(game) if check_winner(game)
      action = game.game_action

      update_players(game)
      game_play(game) if action.is_a? Message
      if action.is_a? User
        broadcast user_id: action.id
        Message.create! content: "#{action.username}'s turn"
        sleep 0.05
        broadcast turn: "#{action.id}"
      end
      update_pot
    end

    def check_winner(game)
      if Game.find(game.id).players.one? { |player| player.action != 2 }
        game.declare_winner(game.players.detect { |player| player.action != 2})
      end
      game.declare_winner if game.stage == "river" && game.players_updated?
    end

    def champion?(game)
      winner = game.find_winner
      return false if winner.is_a? Array
      (game.find_players - [winner]).all? { |player| player.cash <= 0 } &&
        game.stage == "river" && game.players_updated? ||
        (game.find_players - [winner]).all? { |player| player.action == 2 }
    end

    def declare_champion(game)
      check_winner(game)
      game.update(started: false)
      champion = game.players.detect { |player| player.cash > 0 }
      game.reset_game
      game.update(ordered_players: [])
      game.ai_players = []
      users_with_zero = game.users.where(cash: 0)
      game.users.delete(users_with_zero)
      broadcast new_game: "new_game"
      Message.create! content: "#{champion.username} is the winner!"
    end

    def reset_table(game)
      sleep 4
      game.reset_game
      broadcast clear_table: "clear_table"
      game.set_up_game
      update_players(game)
      broadcast start_game: "start_game"
    end

    def start_game(game)
      return Message.create! content: "There must be at least 2 players to start" if Game.find(game.id).players.count < 2
      game.update(started: true)
      game.set_up_game

      update_players(game)
      broadcast start_game: "start_game"
      Message.create! content: "THE GAME HAS STARTED!"
      game_play(game)
    end

    def update_players(game)
      RenderPlayerJob.perform_later game
    end
end
