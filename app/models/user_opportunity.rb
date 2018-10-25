class UserOpportunity < ApplicationRecord
  enum status: [:review, :pending, :applied, :trash]
  belongs_to :user
  belongs_to :opportunity
end
