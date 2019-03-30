# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  include Response
  include ExceptionHandler
  acts_as_token_authentication_handler_for User
  before_action :set_params, only: %i[create]

  def create
    logger.info "API called to create new opportunity..."
    logger.info "Parameters: #{@params}"

    opportunity = Opportunity.find_or_create(url: @params[:url], params: @params)
    return json_error("failed to create opportunity", :unprocessable_entity) if opportunity.nil?

    user_opportunity = UserOpportunity.find_or_create(opportunity: opportunity, user: current_user, params: @params)
    return json_error("failed to create user_opportunity", :unprocessable_entity) if user_opportunity.nil?

    response = {
      user:             current_user,
      user_opportunity: user_opportunity,
      opportunity:      opportunity,
      company:          opportunity.company,
      job:              opportunity.job,
      sector:           opportunity.sector
    }
    logger.debug "API response: #{response}"
    json_response(data: response)
  end

  protected

  def set_params
    params.require(:opportunity).require(REQUIRED_PARAMS.keys)
    received_params = params.require(:opportunity).permit(ALL_PARAMS.keys)
    sanitizer = BatchSanitizerService.new(received_params, ALL_PARAMS, DEFAULT_PARAMS)
    @params = clean_params(sanitizer.call)
  end

  def clean_params(params)
    params[:job_name] ||= params[:title]
    params
  end

  REQUIRED_PARAMS =
    {
      job_description: :md,
      stars:           :integer,
      url:             :url
    }.freeze

  OPTIONAL_PARAMS =
    {
      contract_type:     :contract_type,
      company_name:      :string,
      company_structure: :company_structure,
      email:             :email,
      location:          :location,
      logo:              :url,
      job_category:      :string,
      job_name:          :string,
      salary:            :integer,
      sector_category:   :string,
      sector_name:       :string,
      start_date:        :date,
      title:             :string
    }.freeze

  ALL_PARAMS = REQUIRED_PARAMS.merge(OPTIONAL_PARAMS)

  DEFAULT_PARAMS =
    {
      sector_name: "Other"
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
