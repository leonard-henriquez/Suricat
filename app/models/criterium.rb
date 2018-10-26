class Criterium < ApplicationRecord
  enum type: [:contract_type, :structure, :industry, :job, :geography, :salary]
  belongs_to :user
  validates :type, presence: true
  validates :value, presence: true
end
