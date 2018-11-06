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

  validates :automatic_grade, presence: true
  validates :personnal_grade, presence: true

  before_validation :grade_calculation

  (Opportunity.attribute_names - attribute_names).each do |attr|
    delegate attr.to_sym, to: :opportunity, allow_nil: true
  end

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  private

  # ! start methods for automatic_grade calculation !
  def importances_value
    @importances_value = []
    6.times do |i|
      i += 1
      importance_value = Importance.where(name: i).value
      if importance_value.nil?
        @importances_value.push(0)
      else
        @importances_value.push(importance_value)
      end
    end
  end

  def criteria_tab
    @criteria = []
    6.times do |i|
      i += 1
      criteria = Criterium.where(importance_id: i).map(&:value.to_proc)
      @criteria.push(criteria)
    end
  end

  def user_opportunity_criteria
    @user_opportunity_criteria = [
      @user_opportunity.contract_type,
      @user_opportunity.company.structure,
      @user_opportunity.sector.name,
      @user_opportunity.job.name,
      @user_opportunity.location,
      @user_opportunity.salary
    ]
  end

  def check_criterium
    @criterium_matching = []
    5.times do |i|
      if @criteria[i].include?(@user_opportunity_criteria[i])
        @criterium_matching.push(1)
      else
        @criterium_matching.push(0)
      end
    end
    if @user_opportunity_criteria[5] >= @criteria[5].to_i
      @criterium_matching.push(1)
    else
      @criterium_matching.push(0)
    end
  end

  def grade_calculation
    automatic_grade = 0
    6.times do |i|
      automatic_grade += (@criterium_matching[i] * @importances_value[i] / 6).to_i
    end
    @user_opportunity.automatic_grade = automatic_grade
    @user_opportunity.save
  end
end
