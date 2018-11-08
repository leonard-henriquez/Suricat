# frozen_string_literal: true

class Importance < ApplicationRecord
  enum name: %i[contract_type company_structure sector_name job location salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy
end
