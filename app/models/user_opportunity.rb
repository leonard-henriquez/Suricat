# frozen_string_literal: true

require_relative "criterium"
require_relative "importance"

class UserOpportunity < ApplicationRecord
  enum status: %i[review pending applied trash]
  belongs_to :user
  belongs_to :opportunity
  has_one :job, through: :opportunity
  has_one :company, through: :opportunity
  has_one :sector, through: :opportunity
  after_initialize :init

  validates :personnal_grade, presence: true

  before_save :grade_calculation

  (Opportunity.attribute_names - attribute_names).each do |attr|
    delegate attr.to_sym, to: :opportunity, allow_nil: true
  end

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def init
    self.status ||= :review
  end

  def personnal_grade=(value)
    value = value.to_s.gsub(/\D/, "").to_i
    super(value)
  end

  # ! start methods for automatic_grade calculation !
  def grade_calculation
    grade = 0
    criterium_matching.each_with_index do |_, i|
      grade += criterium_matching[i] * importances_value[i]
    end
    self.automatic_grade = grade.fdiv(6).to_i
  end

  def importances_value
    user.importances.map { |i| i.value || 0 }
  end

  def criteria
    user.importances.map { |i| i.criteria.map(&:value.to_proc) }
  end

  def user_opportunity_criteria
    [
      contract_type,
      company_structure,
      sector_name,
      job_name,
      location,
      salary
    ]
  end

  def criterium_matching
    criterium_matching = []
    criteria.each_with_index do |_, i|
      criterium_matching.push(test_to_int(criteria[i], user_opportunity_criteria[i]))
    end
    criterium_matching
  end

  def test(criteria_values, value)
    is_number?(criteria_values.first) ? (value || 0) >= criteria_values.first.to_i : criteria_values.include?(value)
  end

  def test_to_int(criteria_values, value)
    test(criteria_values, value) ? 1 : 0
  end

  def is_number?(value)
    true if Float(value)
  rescue StandardError
    false
  end
end
