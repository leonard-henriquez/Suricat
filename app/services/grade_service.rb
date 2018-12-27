# frozen_string_literal: true

class GradeService
  CALCULATION_CONSTANT = Math.log(2)
  POSITION_CONSTANT = 0.9
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

      logger.info "key: #{key}, value: #{value}, importance: #{importances_value[key]}"
      total_importances_values += importances_value[key]
      grade += value * importances_value[key]
    end
    logger.info "total importances: #{total_importances_values}"
    logger.info "grade: #{(grade * 100).fdiv(total_importances_values)}"
    (grade * 100).fdiv(total_importances_values).to_i
  rescue StandardError => e
    logger.info "%%%%%% Grade calculation failed %%%%%%"
    logger.info e.inspect
    logger.info "criterium_matching: #{criterium_matching}"
    logger.info "importances_value: #{importances_value}"
    0
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
    return 0 if range.is_a?(Array) && range.empty?

    case type
    when :integer
      distance(value, range)
    when :enum
      position(value, range)
    when :string
      position(value, range)
    when :location
      dist = range.map { |criteria_value| Geocoder::Calculations.distance_between(criteria_value, value) }.min
      distance(dist, MAX_DISTANCE, true)
    end
  end

  def position(value, range)
    return 0 unless range.include?(value)

    pseudo_rank = POSITION_CONSTANT**range.index(value)
    Math.exp(CALCULATION_CONSTANT * pseudo_rank) - 1
  end

  def distance(value, reference, negative=false)
    if negative
      value = -value
      reference = -reference
    end

    return 1 if value >= reference
    return 0 if value <= 0

    Math.exp(CALCULATION_CONSTANT * value.fdiv(reference)) - 1
  end
end
