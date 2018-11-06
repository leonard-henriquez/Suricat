# frozen_string_literal: true

class UserOpportunity < ApplicationRecord
  enum status: %i[review pending applied trash]
  belongs_to :user
  belongs_to :opportunity
  has_one :job, through: :opportunity
  has_one :company, through: :opportunity
  has_one :sector, through: :opportunity

  validates :automatic_grade, presence: true
  validates :personnal_grade, presence: true

  (Opportunity.attribute_names - attribute_names).each do |attr|
    delegate attr.to_sym, to: :opportunity, allow_nil: true
  end

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def grade_calculation(criterium_matching, importances)
    grade = 0
    (0..5).each do |i|
      grade += criterium_matching[i] * importances [i]
    end
  end

  def check_criterium(criterium, opportunity_attributes)
    criterium_matching = []
    (0..5).each do |i|
      if criterium[i].include?(opportunity_attributes[i])
        criterium_matching.push(1)
      else
        criterium_matching.push(0)
      end
    end
  end
end
