# frozen_string_literal: true

class Criterium < ApplicationRecord
  belongs_to :importance

  def self.types
    {
      contract_type:     :enum,
      company_structure: :enum,
      sector_name:       :enum,
      job_name:          :enum,
      location:          :location,
      salary:            :integer
    }
  end
end
