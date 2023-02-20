class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid do |invalid|
    render json: {errors: invalid.record.errors}, status: 422
  end


  def per_page
    params[:per_page] || 10
  end

  def page
    params[:page] || 1
  end
end
