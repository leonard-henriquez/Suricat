# frozen_string_literal: true

class CriteriaStandardizerService
  def initialize(criteria_list, has_multiple_values=false)
    @criteria_list = criteria_list
    @has_multiple_values = has_multiple_values
  end

  def call
    cleaned_list = {}
    criterium_types = Criterium.types
    @criteria_list.each do |criterium, values|
      next unless criterium_types.key?(criterium)

      type = criterium_types[criterium]
      clean_value = @has_multiple_values ? values.map { |value| clean_value(value, type) } : clean_value(values, type)
      cleaned_list[criterium] = clean_type(clean_value, type)
    end
    cleaned_list
  end

  private

  def clean_value(value, type)
    case type
    when :integer, :enum
      value.to_i
    when :string
      value.to_s
    when :location
      if @has_multiple_values
        hash = JSON.parse(value)
        [(hash["lat"] || 0).to_f, (hash["lng"] || 0).to_f] if hash.key?("lat") && hash.key?("lng")
      else
        [(value[0] || 0).to_f, (value[1] || 0).to_f]
      end
    end
  end

  def clean_type(value, type)
    case type
    when :integer
      @has_multiple_values ? value.first : value
    else
      @has_multiple_values ? value.reject { |x| x.nil? || x == "" } : value
    end
  end
end
