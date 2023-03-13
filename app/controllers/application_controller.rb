class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, JWTSessions::Errors::Expired, with: :not_authorized
  rescue_from ActiveRecord::RecordInvalid do |invalid|
    render json: {errors: invalid.record.errors}, status: 422
  end

  private

    # TODO: Fix method when payload it is not present
    #def current_user
    #  @current_user ||= User.find(payload['user_id'])
    #end

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
end
