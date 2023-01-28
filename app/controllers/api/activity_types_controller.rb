module Api
  class ActivityTypesController < ApplicationController
    def create
      ActivityType.create!(params[:activity_type])
    end

    def index
      activity_types = ActivityType.all
      render json: activity_types
    end
  end
end