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
      user:             @user,
      user_opportunity: user_opportunity,
      opportunity:      opportunity
    }
    render json: response
  end

  private

  def create_user_opportunity(opportunity)
    UserOpportunity.create(
      user:            current_user,
      opportunity:     opportunity,
      personnal_grade: p[:stars].to_i,
      status:          :review
    )
  end

  def create_opportunity
    job = Job.find_by(name: p[:job_name])
    job = create_job if job.nil?

    company = Company.find_by(name: p[:company_name])
    company = create_company if company.nil?

    Opportunity.create(
      job:             job,
      company:         company,
      contract_type:   p[:contract_type],
      salary:          p[:salary],
      job_description: p[:job_description],
      location:        p[:location],
      url:             p[:url],
      title:           p[:title],
      logo:            p[:logo]
    )
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
    params.require(:opportunity).permit(
      :company_name,
      :company_structure,
      :contract_type,
      :logo,
      :job_description,
      :job_name,
      :location,
      :start_date,
      :title,
      :url,
      :salary,
      :email,
      :stars
    )
  end
end
