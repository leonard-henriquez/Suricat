# frozen_string_literal: true

class JobCategory < ApplicationRecord
  has_many :jobs
  has_many :opportunities, through: :jobs

  validates :name, presence: true, uniqueness: true

  def self.find_or_create(name:)
    find_or_create_by(name: name)
  end
end
