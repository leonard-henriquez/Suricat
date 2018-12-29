# frozen_string_literal: true

class SectorCategory < ApplicationRecord
  has_many :sectors
  has_many :opportunities, through: :sectors

  validates :name, presence: true, uniqueness: true

  def self.find_or_create(name:)
    find_or_create_by(name: name)
  end
end
