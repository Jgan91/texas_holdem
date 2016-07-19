class Game < ApplicationRecord
  has_many :ai_players
  has_many :users

  def players
    users + ai_players
  end
end
