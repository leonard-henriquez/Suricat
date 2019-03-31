# frozen_string_literal: true

class Opportunity < ApplicationRecord
  enum contract_type: [:internship, :vie, :graduate_program, :fixed_term, :full_time, :apprenticeship, :other]

  belongs_to :job, optional: true
  belongs_to :company, optional: true
  belongs_to :sector, optional: true

  has_one :job_category, through: :job
  has_one :sector_category, through: :sector
  has_many :user_opportunities, dependent: :destroy
  has_many :users, through: :user_opportunities

  validates :url, presence: true, uniqueness: true
  validates :job_description, presence: true

  geocoded_by :company_location
  after_validation :geocode, if: :will_save_change_to_location?
  before_save :set_default_values

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
    company.nil? ? location : [company.name, location].compact.join(', ')
  end

  def characteristics
    {
      contract_type: contract_type_id,
      company_structure: company.nil? ? nil : company.structure_id,
      sector_name: sector_id,
      job_name: job_id,
      location: [(latitude || 0).to_f, (longitude || 0).to_f],
      salary: salary
    }
  end

  def self.find_or_create(url:, params: nil)
    item = find_by(url: url)
    return item unless item.nil?

    raise ArgumentError, 'Missing params' if params.nil?

    opportunity_params = filter_params(params)
    dependencies_params = create_dependencies(params)
    create(opportunity_params.merge(dependencies_params))
  end

  def self.create_dependencies(params)
    dependencies = {}

    unless params[:company_name].nil?
      dependencies[:company] = Company.find_or_create(
        name: params[:company_name],
        structure: params[:company_structure]
      )
    end

    unless params[:job_name].nil?
      dependencies[:job] = Job.find_or_create(
        name: params[:job_name],
        category: params[:job_category]
      )
    end

    unless params[:sector_name].nil?
      dependencies[:sector] = Sector.find_or_create(
        name: params[:sector_name],
        category: params[:sector_category]
      )
    end

    dependencies
  end

  def self.filter_params(params)
    # try to fill all the attributes different than id, company_id, job_id, and sector_id with the $params
    all_params = new.attributes.keys
    puts params
    params = params.select { |x| all_params.include?(x.to_s) && x !~ /id$/ }
    puts params
    params
  end

  protected

  def set_default_values
    self.logo ||= '/images/default_company_logo.png'
  end
end
