class UserOpportunity < ApplicationRecord
  enum status: [:review, :pending, :applied, :trash]
  belongs_to :user
  belongs_to :opportunity
  validates :automatic_grade, presence: true
  validates :personnal_grade, presence: true
end
