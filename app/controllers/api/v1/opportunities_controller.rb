# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    unless current_user
      response = {status: false, errors: "Unable to find user"}
      render json: response
    end

    puts "Opportunity -->"
    opportunity = Opportunity.find_by(url: p[:url])
    opportunity = create_opportunity if opportunity.nil?
    puts opportunity.errors unless opportunity.nil?

    puts "UserOpportunity -->"
    user_opportunity = UserOpportunity.where(opportunity: opportunity, user: current_user).first
    puts user_opportunity
    user_opportunity = create_user_opportunity(opportunity) if user_opportunity.nil?
    puts user_opportunity.errors unless user_opportunity.nil?

    response = {
      status:           true,
      user:             current_user,
      user_opportunity: user_opportunity,
      opportunity:      opportunity
    }
    render json: response
  end

  protected

  def create_user_opportunity(opportunity)
    UserOpportunity.create(
      user:            current_user,
      opportunity:     opportunity,
      personnal_grade: p[:stars]
    )
  end

  def create_opportunity
    job = Job.find_by(name: p[:job_name])
    job = create_job if job.nil?

    company = Company.find_by(name: p[:company_name])
    company = create_company if company.nil?

    create_opportunity_params = {
      job:     job,
      company: company
    }

    unless p[:sector_name].nil?
      sector = Sector.find_by(name: p[:sector_name])
      sector = create_sector if sector.nil?
      create_opportunity_params[sector] = sector
    end

    opportunity_params.each do |param|
      create_opportunity_params[param] = p[param] if p.key?(param)
    end

    opportunity = Opportunity.create(create_opportunity_params)
    puts opportunity.errors unless opportunity.nil?
    opportunity
  end

  def create_company
    structure = p[:company_structure].to_sym
    structures = Company.structures.reject { |s| s == :others }
    structure = :others unless structures.include?(structure)
    company = Company.create(
      name:      p[:company_name],
      structure: structure
    )
    puts company.errors unless company.nil?
    company
  end

  def create_sector
    sector_category = SectorCategory.find_by(name: :other)
    sector_category = SectorCategory.create(name: :other) if sector_category.nil?

    sector = Sector.create(sector_category: sector_category, name: p[:sector_name])
    puts sector.errors unless sector.nil?
    sector
  end

  def create_job
    job_category = JobCategory.find_by(name: :other)
    job_category = JobCategory.create(name: :other) if job_category.nil?

    job = Job.create(job_category: job_category, name: p[:job_name])
    puts job.errors unless job.nil?
    job
  end

  def p
    # (required_params + optional_params).each { |field| p[field] = sanitize(field) }
    params.require(:opportunity).require(required_params)
    params.require(:opportunity).permit(required_params + optional_params)
  end

  def required_params
    %i[
      company_name
      contract_type
      logo
      job_description
      job_name
      location
      title
      url
      stars
    ]
  end

  def optional_params
    %i[
      company_structure
      sector_name
      start_date
      salary
      email
    ]
  end

  def opportunity_params
    %i[
      contract_type
      logo
      job_description
      location
      start_date
      title
      url
      salary
      email
    ]
  end
end
