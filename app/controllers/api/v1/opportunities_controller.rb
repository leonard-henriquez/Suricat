# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @user = current_user

    puts "------------------------------------------"
    puts p[:job_name]
    puts p[:company_name]
    puts "------------------------------------------"

    company = Company.find_by(name: p[:company_name])
    if company.nil?
      structure = p[:company_structure].to_sym
      structures = Company.structures.reject { |s| s == :others }
      structure = :others unless structures.include?(structure)
      company = Company.create(
        name:      p[:company_name],
        structure: structure
      )
    end

    job = Job.find_by(name: p[:job_name])
    if job.nil?
      job = Job.create(name: p[:job_name])
    end

    opportunity = Opportunity.new(
      job:             job,
      company:         company,
      salary:          p[:salary],
      job_description: p[:job_description],
      contract_type:   p[:contract_type].to_s.underscore.to_sym,
      location:        p[:location],
      url:             p[:url]
    )
    opportunity.save
    puts opportunity.errors.inspect
    user_opportunity = UserOpportunity.new(
      user:            @user,
      opportunity:     opportunity,
      automatic_grade: 4,
      personnal_grade: 1,
      status:          :review
    )
    user_opportunity.save

    if @user
      response = {
        status:           true,
        user:             @user,
        user_opportunity: user_opportunity,
        opportunity:      opportunity
      }
      render json: response
    else
      response = {status: false, errors: "Unable to find user"}
      render json: response
    end
  end

  private

  def p
    params.require(:opportunity).permit(
      :company_name,
      :company_structure,
      :contract_type,
      :image,
      :job_description,
      :job_name,
      :location,
      :start_date,
      :title,
      :url,
      :salary,
      :email
    )
  end
end
