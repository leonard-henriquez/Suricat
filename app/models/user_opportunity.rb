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

  # ! start methods for automatic_grade calculation !
  def grade_calculation
    grade = 0
    [0, 1, 2, 3, 4, 5].each do |i|
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
      company.structure,
      sector.name,
      job.name,
      location,
      salary
    ]
  end

  def criterium_matching
    criterium_matching = []
    [0, 1, 2, 3, 4].each do |i|
      if criteria[i].include?(user_opportunity_criteria[i])
        criterium_matching.push(1)
      else
        criterium_matching.push(0)
      end
    end
    if criteria[5][0].nil?
      criterium_matching.push(0)
    elsif user_opportunity_criteria[5] >= criteria[5][0].to_i
      criterium_matching.push(1)
    else
      criterium_matching.push(0)
    end
  end
end
