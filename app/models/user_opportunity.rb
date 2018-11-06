# frozen_string_literal: true

class UserOpportunity < ApplicationRecord
  enum status: %i[review pending applied trash]
  belongs_to :user
  belongs_to :opportunity
  has_one :job, through: :opportunity
  has_one :company, through: :opportunity
  has_one :sector, through: :opportunity

  validates :personnal_grade, presence: true

  (Opportunity.attribute_names - attribute_names).each do |attr|
    delegate attr.to_sym, to: :opportunity, allow_nil: true
  end

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end
end
