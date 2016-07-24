class RenderPlayerJob < ApplicationJob
  queue_as :default

  def perform(game)
    ActionCable.server.broadcast "room_channel", player: render_players(game)
  end

  private
    def render_players(game)
      ApplicationController.renderer.render(partial: "players/player", locals: { game: game})
    end
end
