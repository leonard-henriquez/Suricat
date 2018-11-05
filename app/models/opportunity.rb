# frozen_string_literal: true

class Opportunity < ApplicationRecord
  enum contract_type: %i[internship vie graduate_program fixed_term full_time apprenticeship]
  belongs_to :job
  belongs_to :company
  belongs_to :sector, optional: true
  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities
  has_many :users, through: :user_opportunities
  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true
  validates :contract_type, presence: true
  validates :location, presence: true

  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def contract_type=(contract_type)
    self[:contract_type] = contract_type.to_s.underscore.to_sym unless contract_type.is_a? Symbol
  end

  def salary=(salary)
    salary = salary.to_s.gsub(/\D/, "").to_i
    self[:salary] = salary.zero? ? nil : salary
  end
end
