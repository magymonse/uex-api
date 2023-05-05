class Api::ActivitiesController < Api::BaseController
  before_action :set_activity, only: [:create, :show, :update, :destroy]

  def create
    @activity.save!
    render json: @activity
  end

  def index
    activities = Activity.search(params).includes(:activity_type).paginate(page: page, per_page: per_page)
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
      Activity.includes({professor: :person}, :activity_type, :organizing_organization, :partner_organization, :activity_careers, :beneficiary_detail).find(params[:id])
    else
      Activity.new(activity_params)
    end
  end

  def activity_params
    params[:activity][:activity_careers_attributes] = params[:activity].delete(:activity_careers)
    params[:activity][:beneficiary_detail_attributes] = params[:activity].delete(:beneficiary_detail)

    params.require(:activity).permit(:id, :name, :activity_type_id, :status, :address, :virtual_participation,
      :organizing_organization_id, :partner_organization_id, :project_link, :hours, :ods_vinculation,
      :institutional_program, :institutional_extension_line, :start_date, :end_date, :professor_id,
      beneficiary_detail_attributes: [:id, :activity_id, :number_of_men, :number_of_women, :total],
      activity_careers_attributes: [:id, :career_id, :_destroy],
      activity_weeks_attributes: [:id, :start_date, :end_date]
    )
  end
end
