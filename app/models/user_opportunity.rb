# frozen_string_literal: true

class UserOpportunity < ApplicationRecord
  enum status: [:review, :pending, :applied, :trash]
  belongs_to :user
  belongs_to :opportunity
  has_one :job, through: :opportunity
  has_one :company, through: :opportunity
  has_one :sector, through: :opportunity
  after_initialize :init

  validates :user, presence: true
  validates :opportunity, presence: true
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
  end

  def self.find_or_create(user:, opportunity:, params: nil)
    item = find_by(user: user, opportunity: opportunity)
    return item unless item.nil?

    raise ArgumentError, 'Missing params' if params.nil?

    UserOpportunity.create(
      user: user,
      opportunity: opportunity,
      personnal_grade: params[:stars]
    )
  end

  # ! start methods for automatic_grade calculation !
  def grade_calculation
    grade_calculator = GradeService.new(user, opportunity)
    self.automatic_grade = grade_calculator.call
  end
end
