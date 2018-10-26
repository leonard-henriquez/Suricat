class Importance < ApplicationRecord
  belongs_to :criterium
  validates :value, presence: true
end
