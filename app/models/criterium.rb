class Criterium < ApplicationRecord
  enum criteria_type: [:contract_type, :structure, :industry, :job, :geography, :salary]
  belongs_to :user
end
