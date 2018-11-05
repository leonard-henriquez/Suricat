# frozen_string_literal: true

class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @user = current_user
    opportunity = Opportunity.new(
      job:             Job.first,
      company:         Company.first,
      sector:          Sector.first,
      salary:          1123,
      job_description: "Ceci est un test",
      contract_type:   :vie,
      location:        "Paris",
      url:             "http://suricat.co/",
      latitude:        0,
      longitude:       0
    )
    opportunity.save
    user_opportunity = UserOpportunity.new(
      user:            @user,
      opportunity:     opportunity,
      automatic_grade: 4,
      personnal_grade: 1,
      status:          :pending
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

  def params_sessions
    params.permit
  end
end
