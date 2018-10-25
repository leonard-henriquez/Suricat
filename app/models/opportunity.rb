class Opportunity < ApplicationRecord
  enum contract_type [:internship, :vie, :graduate_program , :fixed_term, :full_time, :apprenticeship]
  belongs_to :job
  belongs_to :company
  belongs_to :sector
end
