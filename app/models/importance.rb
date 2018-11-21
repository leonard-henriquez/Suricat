# frozen_string_literal: true

class Importance < ApplicationRecord
  default_scope { order(:name) }
  enum name: %i[contract_type company_structure sector_name job_name location salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy
end
