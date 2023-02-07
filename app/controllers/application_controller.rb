class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |invalid|
    render json: {errors: invalid.record.errors}, status: 422
  end
end
