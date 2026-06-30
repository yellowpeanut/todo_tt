require_relative "../../lib/errors/errors"

class ApplicationController < ActionController::API
  include Errors
  rescue_from BadRequestError, with: :bad_request
  rescue_from InternalServerError, with: :internal_server_error
  rescue_from StandardError, Exception, with: :unknown_internal_server_error

  private

  def bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end

  def internal_server_error(error)
    render json: { error: error.message }, status: :internal_server_error
  end

  def unknown_internal_server_error(error)
    render json: { error: "unknown internal error has happened" }, status: :internal_server_error
  end
end
