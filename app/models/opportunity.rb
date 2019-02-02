# frozen_string_literal: true

class Opportunity < ApplicationRecord
  enum contract_type: %i[internship vie graduate_program fixed_term full_time apprenticeship other]
  belongs_to :job
  belongs_to :company
  belongs_to :sector, optional: true
  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities, dependent: :destroy
  has_many :users, through: :user_opportunities
  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true
  validates :contract_type, presence: true
  validates :location, presence: true

  geocoded_by :company_location
  after_validation :geocode, if: :will_save_change_to_location?

  [Job, Company, Sector].each do |obj|
    (obj.attribute_names - attribute_names).each do |attr|
      object_name = obj.name.underscore
      delegate attr.to_sym, to: object_name, allow_nil: true, prefix: true
    end
  end

  def contract_type_id
    contract_type_before_type_cast
  end

  def company_location
    company.nil? ? location : [company.name, location].compact.join(", ")
  end

  def characteristics
    {
      contract_type:     contract_type_id,
      company_structure: company.nil? ? nil : company.structure_id,
      sector_name:       sector_id,
      job_name:          job_id,
      location:          [(latitude || 0).to_f, (longitude || 0).to_f],
      salary:            salary
    }
  end

  def self.find_or_create(url:, params: nil)
    item = find_by(url: url)
    return item unless item.nil?

    raise ArgumentError.new("Missing params") if params.nil?

    company = Company.find_or_create(name: params[:company_name], structure: params[:company_structure])
    job     =     Job.find_or_create(name: params[:job_name],     category:  params[:job_category])
    sector  =  Sector.find_or_create(name: params[:sector_name],  category:  params[:sector_category])

    create_opportunity_params = {
      company: company,
      job:     job,
      sector:  sector
    }

    # try to fill all the attributes different than id, company_id, job_id, and sector_id with the $params
    other_params = new.attributes.keys.map(&:to_sym).reject { |x| /^(.*_)?id$/i.match(x) }
    other_params.each { |param| create_opportunity_params[param] = params[param] if params.key?(param) }

    create(create_opportunity_params)
  end
end
