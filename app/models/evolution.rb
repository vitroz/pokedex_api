class Evolution < ApplicationRecord
  belongs_to :pokemon, foreign_key: :pkmn_previous_stage_id, dependent: :destroy
end
