# frozen_string_literal: true

class Importance < ApplicationRecord
  enum name: %i[contract_type structure industry job location salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy
end
