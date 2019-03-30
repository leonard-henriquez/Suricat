# frozen_string_literal: true

module Response
  def json_response(result, status=:ok, message="")
    success = %i[ok created accepted].include?(status)

    response = {
      success: success,
      message: message || "",
      result:  result || []
    }

    render json: response, status: status
  end

  def json_error(message, status=:internal_server_error)
    json_response([], status, message)
  end
end
