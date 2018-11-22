# frozen_string_literal: true

class Company < ApplicationRecord
  enum structure: %i[large_company sme start_up others]
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities
  validates :name, presence: true
  validates :structure, presence: true

  def structure_id
    structure_before_type_cast
  end
end
