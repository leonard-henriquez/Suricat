# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Pundit::NotAuthorizedError do |e|
      json_error(e.message, :unauthorized)
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_error(e.message, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      json_error(e.message, :unprocessable_entity)
    end

    rescue_from StandardError do |e|
      json_error(e.message, :unprocessable_entity)
    end
  end
end
