class Importance < ApplicationRecord
  enum type: [:contract_type, :structure, :industry, :job, :geography, :salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy
end
