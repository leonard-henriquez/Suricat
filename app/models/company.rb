# frozen_string_literal: true

class Company < ApplicationRecord
  enum structure: %i[large_company sme start_up others]
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities

  validates :name, presence: true, uniqueness: true

  def structure_id
    structure_before_type_cast
  end

  def self.find_or_create(name:, structure: nil)
    structure = structure.to_sym unless structure.nil?
    structure = nil unless Company.structures.include?(structure)

    create_with(structure: structure).find_or_create_by(name: name)
  end
end
