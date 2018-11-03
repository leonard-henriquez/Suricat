# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # allow to call $(enum)_name to get displayable value of enum
  # example: UserOpportunity.contract_type_for_display returns "Large company"
  def method_missing(m, *_args)
    m_s = /(.*)_for_display$/.match(m.to_s)
    raise NoMethodError if m_s.nil?

    attr = attribute_names.select do |n|
      type_for_attribute(n).class == ActiveRecord::Enum::EnumType
    end
    attr.include? m_s[1]

    str = send(m_s[1]).to_s.tr("_", " ")
    %w[sme vie].include?(str) ? str.upcase : str.capitalize
  end
end
