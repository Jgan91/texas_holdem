class WinningCardsJob < ApplicationJob
  queue_as :default

  def perform(winning_card)
    ActionCable.server.broadcast "room_channel", winning_card: render_winning_cards(winning_card)
  end

  private
    def render_winning_cards(winning_card)
      ApplicationController.renderer.render(partial: "winning_cards/winning_card", locals: { winning_card: winning_card })
    end
end
