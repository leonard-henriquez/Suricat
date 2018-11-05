# frozen_string_literal: true

class Sector < ApplicationRecord
  belongs_to :sector_category
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities
end
