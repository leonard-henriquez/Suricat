# frozen_string_literal: true

class GradeService
  CALCULATION_CONSTANT = Math::log(2)
  MAX_DISTANCE = 30

  def initialize(user, opportunity)
    @user = user
    @criteria = @user.criteria
    @opportunity = opportunity
    @characteristics = @opportunity.characteristics
  end

  def call
    grade = 0
    total_importances_values = 0
    importances_value = @user.importances_value
    matching = criterium_matching
    matching.each do |key, value|
      next unless importances_value.key?(key)

      puts "key: #{key}, value: #{value}, importance: #{importances_value[key]}"
      total_importances_values += importances_value[key]
      grade += value * importances_value[key]
    end
    puts "total importances: #{total_importances_values}"
    puts "grade: #{(grade * 100).fdiv(total_importances_values)}"
    (grade * 100).fdiv(total_importances_values).to_i
  rescue StandardError => e
    puts "%%%%%% Grade calculation failed %%%%%%"
    puts e.inspect
    puts "criterium_matching: #{criterium_matching}"
    puts "importances_value: #{importances_value}"
    return 0
  end

  def criterium_matching
    matching = {}

    Criterium.types.each do |criterium, type|
      next unless @characteristics.key?(criterium) && @criteria.key?(criterium)

      value = @characteristics[criterium]
      range = @criteria[criterium]
      next if value.nil? || range.nil?

      match = check_matching(type, value, range)

      matching[criterium] = match unless match.nil?
    end

    matching
  end

  private

  def check_matching(type, value, range)
    case type
    when :integer
      distance(value, range)
    when :enum
      range.include?(value) ? 1 : 0
    when :string
      range.include?(value) ? 1 : 0
    when :location
      dist = range.map { |criteria_value| Geocoder::Calculations.distance_between(criteria_value, value) }.min
      distance(dist, MAX_DISTANCE, true)
    end
  end

  def distance(value, reference, negative=false)
    if negative
      value = -value
      reference = -reference
    end

    return 1 if value >= reference
    return 0 if value <= 0

    Math::exp(CALCULATION_CONSTANT * value.fdiv(reference)) - 1
  end
end
