# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  before_action :set_params, only: %i[create]

  def create
    unless current_user
      response = {status: false, errors: "Unable to find user"}
      render json: response
    end
    logger.info "API called to create new opportunity..."
    logger.info "Parameters: #{p}"

    opportunity = Opportunity.find_by(url: @params[:url])
    opportunity = create_opportunity if opportunity.nil?

    user_opportunity = UserOpportunity.where(opportunity: opportunity, user: current_user).first
    user_opportunity = create_user_opportunity(opportunity) if user_opportunity.nil?

    response = {
      status:           true,
      user:             current_user,
      user_opportunity: user_opportunity,
      opportunity:      opportunity,
      company:          opportunity.company,
      job:              opportunity.job,
      sector:           opportunity.sector
    }
    logger.debug "API response: #{response}"
    render json: response
  end

  protected

  def create_user_opportunity(opportunity)
    UserOpportunity.create(
      user:            current_user,
      opportunity:     opportunity,
      personnal_grade: @params[:stars]
    )
  end

  def create_opportunity
    company = Company.find_or_create(name: @params[:company_name], structure: @params[:company_structure])
    job = Job.find_or_create(name: @params[:job_name], category: @params[:job_category])
    sector = Sector.find_or_create(name: @params[:sector_name], category: @params[:sector_category])

    create_opportunity_params = {
      company: company,
      job:     job,
      sector:  sector
    }

    opportunity_params.each do |param|
      create_opportunity_params[param] = @params[param] if @params.key?(param)
    end

    Opportunity.create(create_opportunity_params)
  end

  def set_params
    params.require(:opportunity).require(required_params)
    sanitized_params = {}
    received_params = params.require(:opportunity).permit(required_params + optional_params).each do |key, value|
      if key == :job_description
        sanitized_params[key.to_sym] = ReverseMarkdown.convert(value, unknown_tags: :drop, tag_border: "")
      else
        sanitized_params[key.to_sym] = Sanitize.fragment(value)
      end
    end
    @params = default_params.merge(sanitized_params)
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
      sector_category
      job_category
      start_date
      salary
      email
    ]
  end

  def default_params
    {
      company_structure: "Other",
      sector_name:       "Other",
      sector_category:   "Other",
      job_category:      "Other"
    }
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
