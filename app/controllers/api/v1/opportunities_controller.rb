# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    unless current_user
      response = {status: false, errors: "Unable to find user"}
      render json: response
    end

    opportunity = Opportunity.find_by(url: p[:url])
    opportunity = create_opportunity if opportunity.nil?

    user_opportunity = UserOpportunity.find_by(opportunity: opportunity)
    user_opportunity = create_user_opportunity(opportunity) if user_opportunity.nil?

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

    opportunity_params.each do |param|
      create_opportunity_params[param] = p[param] if p.key?(param)
    end

    Opportunity.create(create_opportunity_params)
  end

  def create_company
    structure = p[:company_structure].to_sym
    structures = Company.structures.reject { |s| s == :others }
    structure = :others unless structures.include?(structure)
    Company.create(
      name:      p[:company_name],
      structure: structure
    )
  end

  def create_job
    Job.create(name: p[:job_name])
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
