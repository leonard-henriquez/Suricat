# frozen_string_literal: true

class RegexSanitizerService
  def initialize(value, regex_table, default_sanitized_value=nil)
    @value = value.to_s.downcase
    @regex_table = regex_table
    @default_sanitized_value = default_sanitized_value
  end

  def call
    @regex_table.each do |sanitized_value, regexes|
      regexes = [regexes] unless regexes.is_a? Array
      return sanitized_value if Regexp.union(regexes).match?(@value)
    end
    @default_sanitized_value
  end
end
