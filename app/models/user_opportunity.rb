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
    total_importances_values = 0
    matching = criterium_matching
    matching.each do |key, value|
      next unless importances_value.key?(key)

      puts "key: #{key}, value: #{value ? 1 : 0}, importance: #{importances_value[key]}"
      total_importances_values += importances_value[key]
      grade += (value ? 1 : 0) * importances_value[key]
    end
    self.automatic_grade = (grade * 100).fdiv(total_importances_values).to_i
  rescue StandardError => e
    puts "%%%%%% Grade calculation failed %%%%%%"
    puts e.inspect
    puts "criterium_matching: #{criterium_matching}"
    puts "importances_value: #{importances_value}"
    self.automatic_grade = 0
  end

  def importances_value
    importances_value = {}
    user.importances.each { |i| importances_value[i.name.to_sym] = i.value || 0 }
    importances_value
  end

  def criteria
    criteria_list = {}
    user.importances.each do |i|
      name = i.name.to_sym
      value = i.criteria.map(&:value.to_proc)
      criteria_list[name] = value
    end

    criteria_list
  rescue StandardError => e
    puts "%%%%%% Criteria failed %%%%%%"
    puts e.inspect
    puts criteria_list.inspect
  end

  def user_opportunity_criteria
    location = [(latitude || 0).to_f, (longitude || 0).to_f]
    {
      contract_type:     contract_type,
      company_structure: company_structure,
      sector_name:       sector_name,
      job_name:          job_name,
      location:          location,
      salary:            salary
    }
  end

  def self.criteria_type
    {
      contract_type:     :enum,
      company_structure: :enum,
      sector_name:       :enum,
      job_name:          :enum,
      location:          :location,
      salary:            :integer
    }
  end

  def criterium_matching
    op_criteria = user_opportunity_criteria
    user_criteria = criteria
    matching = {}

    self.class.criteria_type.each do |criterium, type|
      next unless op_criteria.key?(criterium) && user_criteria.key?(criterium)

      value = op_criteria[criterium]
      range = user_criteria[criterium]
      next if value.nil? || range.nil?
      match = check_matching(type, value, range)

      matching[criterium] = match unless match.nil?
    end

    matching
  end

  def check_matching(type, value, range)
    if type == :integer
      value = value.first if value.is_a? Array
      value = value.to_i

      range = range.first if range.is_a? Array
      range = range.to_i
      return value > range
    elsif type == :enum
      value = value.to_i
      range.map!(&:to_i)
      return range.include?(value)
    elsif type == :string
      value = value.to_s
      range.map!(&:to_s)
      return range.include?(value)
    elsif type == :location
      return nil unless value.is_a? Array

      range = range.map do |json|
        hash = JSON.parse(json)
        [(hash["lat"] || 0).to_f, (hash["lng"] || 0).to_f] if hash.key?("lat") && hash.key?("lng")
      end
      range = range.compact
      radius = 30
      return range.any? { |criteria_value| in_circle?(criteria_value, value, radius) }
    end
  end

  def in_circle?(point1, point2, radius)
    Geocoder::Calculations.distance_between(point1, point2) < radius
  end
end
