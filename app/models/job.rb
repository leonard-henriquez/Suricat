class Job < ApplicationRecord
  belongs_to :job_category
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities
end
