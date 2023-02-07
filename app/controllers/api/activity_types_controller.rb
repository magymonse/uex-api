module Api
  class ActivityTypesController < ApplicationController
    before_action :set_activity_type, only: [:create, :show, :update, :destroy]

    def create
      @activity_type.save!
      render json: @activity_type
    end

    def index
      activity_types = ActivityType.all
      render json: activity_types
    end

    def show
      render json: @activity_type
    end

    def update
      @activity_type.update!(activity_type_params)
      render json: @activity_type
    end

    def destroy
      @activity_type.destroy!
    end

    private
    def set_activity_type
      @activity_type = if params[:id]
        ActivityType.find(params[:id])
      else
        ActivityType.new(activity_type_params)
      end
    end

    def activity_type_params
      params.require(:activity_type).permit(:name, :description)
    end
  end
end