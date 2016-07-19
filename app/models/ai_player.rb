class AiPlayer < ApplicationRecord
  validates_presence_of :username
  validates_uniqueness_of :username
  belongs_to :game, required: false
end
