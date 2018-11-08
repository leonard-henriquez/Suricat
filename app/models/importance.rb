# frozen_string_literal: true

class Importance < ApplicationRecord
  enum name: %i[contract_type company_structure sector_name job location salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy

  # accepts_nested_attributes_for :criteria

  def criteria_attributes=(attributes)
    values = attributes[:value]

    # delete previous values
    criteria.destroy_all

    # rewrite them all
    values.each do |value|
      criterium = Criterium.new(value: value)
      criterium.importance = self
      criterium.save
    end
  end
end
