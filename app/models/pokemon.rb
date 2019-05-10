class Pokemon < ApplicationRecord
  has_many :evolutions, foreign_key: :pkmn_previous_stage_id, dependent: :destroy
  has_many :types_pokemon
  has_many :types, through: :types_pokemon


  validates_presence_of :name
end
