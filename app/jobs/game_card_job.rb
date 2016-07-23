class GameCardJob < ApplicationJob
  queue_as :default

  def perform(game_card)
    ActionCable.server.broadcast "room_channel", game_card: render_game_card(game_card)
  end

  private
    def render_game_card(game_card)
      ApplicationController.renderer.render(partial: "game_cards/game_card", locals: { game_card: game_card })
    end
end
