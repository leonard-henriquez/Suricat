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
    logger.info "Parameters: #{@params}"

    opportunity = Opportunity.find_or_create(url: @params[:url], params: @params)
    # opportunity = Opportunity.find_by(url: @params[:url])
    # opportunity = create_opportunity if opportunity.nil?

    user_opportunity = UserOpportunity.find_or_create(opportunity: opportunity, user: current_user, params: @params)
    # user_opportunity = UserOpportunity.find_by(opportunity: opportunity, user: current_user)
    # user_opportunity = create_user_opportunity(opportunity) if user_opportunity.nil?

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

  # def create_user_opportunity(opportunity)
  #   UserOpportunity.create(
  #     user:            current_user,
  #     opportunity:     opportunity,
  #     personnal_grade: @params[:stars]
  #   )
  # end

  # def create_opportunity
  #   company = Company.find_or_create(name: @params[:company_name], structure: @params[:company_structure])
  #   job     = Job.find_or_create(name: @params[:job_name], category: @params[:job_category])
  #   sector  = Sector.find_or_create(name: @params[:sector_name], category: @params[:sector_category])

  #   create_opportunity_params = {
  #     company: company,
  #     job:     job,
  #     sector:  sector
  #   }

  #   OPPORTUNITY_PARAMS.each do |param|
  #     create_opportunity_params[param] = @params[param] if @params.key?(param)
  #   end

  #   Opportunity.create(create_opportunity_params)
  # end

  def set_params
    params.require(:opportunity).require(REQUIRED_PARAMS.keys)
    received_params = params.require(:opportunity).permit(ALL_PARAMS.keys)
    sanitizer = BatchSanitizerService.new(received_params, ALL_PARAMS, DEFAULT_PARAMS)
    @params = sanitizer.call
  end

  REQUIRED_PARAMS =
    {
      company_name:    :string,
      contract_type:   :contract_type,
      logo:            :url,
      job_description: :md,
      job_name:        :string,
      location:        :location,
      title:           :string,
      url:             :url,
      stars:           :integer
    }.freeze

  OPTIONAL_PARAMS =
    {
      company_structure: :company_structure,
      sector_name:       :string,
      sector_category:   :string,
      job_category:      :string,
      start_date:        :date,
      salary:            :integer,
      email:             :email
    }.freeze

  ALL_PARAMS = REQUIRED_PARAMS.merge(OPTIONAL_PARAMS)

  DEFAULT_PARAMS =
    {
      company_structure: "Other",
      sector_name:       "Other",
      sector_category:   "Other",
      job_category:      "Other"
    }.freeze

  OPPORTUNITY_PARAMS =
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
    ].freeze
end
