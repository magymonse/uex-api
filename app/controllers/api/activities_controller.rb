class Api::ActivitiesController < Api::BaseController
  before_action :set_activity, only: [:create, :show, :update, :destroy]

  def create
    @activity.save!
    render json: @activity
  end

  def index
    activities = Activity.search(params).paginate(page: page, per_page: per_page)
    render json: activities, each_serializer: ActivitySerializer, meta: meta_attributes(activities)
  end

  def meta_attributes(activities)
    { 
      per_page: per_page,
      total_pages: activities.total_pages,
      total_objects: activities.total_entries
    }
  end

  def show
    render json: @activity
  end

  def update
    @activity.update!(activity_params)
    render json: @activity
  end

  def destroy
    @activity.destroy!
  end

  private
  def set_activity
    @activity = if params[:id]
      Activity.find(params[:id])
    else
      Activity.new(activity_params)
    end
  end

  def activity_params
    params.require(:activity).permit(:id, :name, :activity_type_id, :status, :address, :virtual_participation, :organizing_organization_id, :parther_organization_id, :project_link, :hours, :ods_vinculation, :institutional_program, :institutional_extension_line, :start_date, :end_date,
      beneciary_detail_attributes: [:id, :activity_id, :number_of_men, :number_of_women, :total],
      activity_careers_attributes: [:id, :activity_id, :career_id],
      activity_weeks_attributes: [:id, :start_date, :end_date]
    )
  end
end
