class Company < ApplicationRecord
  enum structure [:large_company, :sme, :start_up, :others]
end
