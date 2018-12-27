# frozen_string_literal: true

class Sector < ApplicationRecord
  belongs_to :sector_category
  alias_attribute :category, :sector_category
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities

  validates :name, presence: true, uniqueness: true

  before_validation :sanitize, on: %i[create update]

  def self.category
    (to_s + "Category").constantize
  end

  def sanitize
    self.name = Sanitize.fragment(name)
  end

  def self.find_or_create(name:, category: nil)
    item = find_by(name: name)
    return item unless item.nil?

    raise ArgumentError.new("Missing category") if category.nil?

    category = self.category.find_or_create(name: category)
    create(name: name, category: category)
  end
end
