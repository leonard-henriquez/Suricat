class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  # allow to call $(enum)_name to get displayable value of enum
  # example: UserOpportunity.contract_type_for_display returns "Large company"
  def method_missing(m, *args, &block)
    m_s = /(.*)_for_display$/.match(m.to_s)
    raise NoMethodError if m_s.nil?

    attr = self.attribute_names.select do |n|
      self.type_for_attribute(n).class == ActiveRecord::Enum::EnumType
    end
    attr.include? m_s[1]

    str = send(m_s[1]).to_s.gsub('_', ' ')
    ['sme', 'vie'].include?(str) ? str.upcase : str.capitalize
  end
end
