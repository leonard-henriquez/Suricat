# frozen_string_literal: true

class Importance < ApplicationRecord
  enum name: %i[contract_type structure industry job location salary]
  belongs_to :user
  has_many :criteria, dependent: :destroy

  # accepts_nested_attributes_for :criteria

  def criteria_attributes=(attributes)
    values = attributes[:value]

    # delete previous values
    self.criteria.destroy_all

    # rewrite them all
    values.each do |value|
      criterium = Criterium.new(value: value)
      criterium.importance = self
      criterium.save
    end
  end
end
