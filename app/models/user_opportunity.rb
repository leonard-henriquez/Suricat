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
    grade_calculator = GradeService.new(user, opportunity)
    self.automatic_grade = grade_calculator.call
  end
end
