# frozen_string_literal: true

class JobCategory < ApplicationRecord
  has_many :jobs
  has_many :opportunities, through: :jobs
end
