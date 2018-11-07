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
    self.importances_value
    self.criteria_tab
    self.user_opportunity_criteria
    self.check_criterium
    grade = 0
    [0,1,2,3,4,5].each do |i|
      grade += (@criterium_matching[i] * @importances_value[i] / 6).to_i
    end
    self.automatic_grade = grade
  end

  def importances_value
    @importances_value = []
    [0,1,2,3,4,5].each do |i|
      importance_value = Importance.find_by(name: i).value
      if importance_value.nil?
        @importances_value.push(0)
      else
        @importances_value.push(importance_value)
      end
    end
  end

  def criteria_tab
    @criteria = []
    [1,2,3,4,5,6].each do |i|
      criteria = Criterium.where(importance_id: i).map(&:value.to_proc)
      @criteria.push(criteria)
    end
  end

  def user_opportunity_criteria
    @user_opportunity_criteria = [
      self.contract_type,
      self.company.structure,
      self.sector.name,
      self.job.name,
      self.location,
      self.salary
    ]
  end

  def check_criterium
    @criterium_matching = []
    [0,1,2,3,4,5].each do |i|
      if @criteria[i].include?(@user_opportunity_criteria[i])
        @criterium_matching.push(1)
      else
        @criterium_matching.push(0)
      end
    end
    if @user_opportunity_criteria[5] >= @criteria[5][0].to_i
      @criterium_matching.push(1)
    else
      @criterium_matching.push(0)
    end
  end
end
