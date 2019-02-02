# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :job_category, optional: true
  alias_attribute :category, :job_category
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities

  validates :name, presence: true, uniqueness: true

  def self.category
    (to_s + "Category").constantize
  end

  def self.find_or_create(name:, category: nil)
    item = find_by(name: name)
    return item unless item.nil?

    raise ArgumentError.new("Missing category") if category.nil?

    category = self.category.find_or_create(name: category)
    create(name: name, category: category)
  end
end
