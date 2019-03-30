# frozen_string_literal: true

class Sector < ApplicationRecord
  belongs_to :sector_category, optional: true
  alias_attribute :category, :sector_category
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities

  validates :name, presence: true, uniqueness: true

  def self.category
    (to_s + "Category").constantize
  end

  def self.find_or_create(name:, category: nil)
    item = find_by(name: name)
    return item unless item.nil?

    category = self.category.find_or_create(name: category) unless category.nil?
    create(name: name, category: category)
  end
end
