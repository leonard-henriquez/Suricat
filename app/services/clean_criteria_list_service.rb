# frozen_string_literal: true

class CleanCriteriaListService
  def initialize(criteria_list, is_array=false)
    @criteria_list = criteria_list
    @is_array = is_array
  end

  def call
    cleaned_list = {}
    criterium_types = Criterium.types
    @criteria_list.each do |criterium, values|
      if criterium_types.key?(criterium)
        type = criterium_types[criterium]
        clean_value = @is_array ? values.map { |value| clean_value(value, type) } : clean_value(values, type)
        cleaned_list[criterium] = clean_type(clean_value, type)
      end
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
      if @is_array
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
      @is_array ? value.first : value
    else
      @is_array ? value.compact : value
    end
  end
end
