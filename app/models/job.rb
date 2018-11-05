# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :job_category, optional: true
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities
end
