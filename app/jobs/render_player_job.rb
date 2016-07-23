class RenderPlayerJob < ApplicationJob
  queue_as :default

  def perform(player)
    ActionCable.server.broadcast "room_channel", player: render_player(player)
  end

  private
    def render_player(player)
      ApplicationController.renderer.render(partial: "players/player", locals: { player: player})
    end
end
