class Card < ApplicationRecord
  belongs_to :game, required: false
  belongs_to :user, required: false
  belongs_to :ai_player, required: false
end
