class Company < ApplicationRecord
  enum structure: [:large_company, :sme, :start_up, :others]
  has_many :opportunities
  has_many :user_opportunities, through: :opportunities
end
