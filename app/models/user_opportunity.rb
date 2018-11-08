# frozen_string_literal: true

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
    self.personnal_grade ||= 0
    self.automatic_grade ||= 0
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
    criteria_list = user.importances.map { |i| i.criteria.map(&:value.to_proc) }

    coords_list = []
    unless criteria_list[4].first.nil?
      criteria_list[4].each do |json|
        hash = JSON.parse(json)
        coords_list.push [hash["lat"], hash["lng"]]
      end
    end
    criteria_list[4] = coords_list
    criteria_list
  end

  def user_opportunity_criteria
    [
      contract_type,
      company_structure,
      sector_name,
      job_name,
      [latitude, longitude],
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
    if criteria_values.first.is_a? Array
      radius = 30
      criteria_values.any? { |criteria_value| in_circle?(criteria_value, value, radius) }
    elsif is_number?(criteria_values.first)
      (value.to_i || 0) >= criteria_values.first.to_i
    else
      criteria_values.include?(value)
    end
  end

  def test_to_int(criteria_values, value)
    test(criteria_values, value) ? 1 : 0
  end

  def is_number?(value)
    true if Float(value)
  rescue StandardError
    false
  end

  def in_circle?(point1, point2, radius)
    Geocoder::Calculations.distance_between(point1, point2) < radius
  end
end
