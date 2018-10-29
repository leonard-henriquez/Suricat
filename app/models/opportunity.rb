class Opportunity < ApplicationRecord
  enum contract_type: [:internship, :vie, :graduate_program , :fixed_term, :full_time, :apprenticeship]
  belongs_to :job
  belongs_to :company
  belongs_to :sector
  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities
  has_many :users, through: :user_opportunities
  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true
  validates :contract_type, presence: true
  validates :location, presence: true
end
