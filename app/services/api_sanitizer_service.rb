# frozen_string_literal: true

class ApiSanitizerService
  def initialize(value, regex_table, default_key=nil)
    @value = value
    @regex_table = regex_table
    @default_key = default_key
  end

  def call
    @regex_table.each do |key, regex|
      return key if regex.match?(@value)
    end
    @default_key
  end
end
