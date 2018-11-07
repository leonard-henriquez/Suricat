# frozen_string_literal: true

class Opportunity < ApplicationRecord
  enum contract_type: %i[internship vie graduate_program fixed_term full_time apprenticeship other]
  belongs_to :job
  belongs_to :company
  belongs_to :sector, optional: true
  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities, dependent: :destroy
  has_many :users, through: :user_opportunities
  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true
  validates :contract_type, presence: true
  validates :location, presence: true

  geocoded_by :company_location
  after_validation :geocode, if: :will_save_change_to_location?

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def contract_type=(value)
    unless value.is_a? Symbol
      sanitizer = ApiSanitizerService.new(value, contract_types_format, :other)
      value = sanitizer.call
    end
    super(value)
  end

  def salary=(value)
    value = value.to_s.gsub(/\D/, "").to_i
    super(value.zero? ? nil : value)
  end

  def company_location
    company.nil? ? location : [company.name, location].compact.join(", ")
  end

  protected

  def contract_types_format
    {
      internship:       /internship/,
      vie:              /vie/,
      graduate_program: /graduate program/,
      full_time:        /full.time/,
      fixed_term:       /fixed.(term|time)/
    }
  end
end
