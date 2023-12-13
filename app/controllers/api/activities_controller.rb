class Api::ActivitiesController < Api::BaseController
  before_action :set_activity, only: [:show, :update, :destroy, :update_status]

  def create
    result = CreateActivityServices.call(activity_params)

    render json: result[:record]
  end

  def index
    activities = Activity.search(params).includes(includes).paginate(page: page, per_page: per_page)
    render json: activities, each_serializer: ActivitySerializer, meta: meta_attributes(activities)
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

  def update_status
    result = Models::ActivityStatusServices.call(@activity, params)

    render json: result
  end

  def export_project_list_report
    result = Exports::ProjectListReportGeneratorServices.call(params)

    send_data(
      result[:data_stream],
      filename: result[:filename],
      disposition: 'attachment',
    )
  end

  def export_statistical_report
    result = Exports::StatisticalReportGeneratorServices.call(params)

    send_data(
      result[:data_stream],
      filename: result[:filename],
      disposition: 'attachment',
    )
  end

  private
  def set_activity
    @activity = if params[:id]
      Activity.includes(includes).find(params[:id])
    end
  end

  # Currently this method is also used in the index serializer we should create a different includes method to preload data on index actions
  # and pass as well to the serializer so that it doesn't try to load unnecesary data only if it's specified
  def includes
    [ :activities_activity_sub_types, :activity_sub_types, :organizing_organization, :partner_organization, :activity_careers, :careers, :beneficiary_detail, {professor: :person} ]
  end

  def activity_params
    params[:activity][:activity_careers_attributes] = params[:activity].delete(:activity_careers)
    params[:activity][:beneficiary_detail_attributes] = params[:activity].delete(:beneficiary_detail)
    params[:activity][:activities_activity_sub_types_attributes] = params[:activity].delete(:activities_activity_sub_types)

    params.require(:activity).permit(:id, :name, :status, :address, :virtual_participation,
      :organizing_organization_id, :partner_organization_id, :project_link, :hours, :ods_vinculation,
      :institutional_program, :institutional_extension_line, :start_date, :end_date, :objective, :professor_id,
      beneficiary_detail_attributes: [:id, :activity_id, :number_of_men, :number_of_women, :total],
      activity_careers_attributes: [:id, :career_id, :_destroy],
      activities_activity_sub_types_attributes: [:id, :activity_sub_type_id, :_destroy],
      activity_weeks_attributes: [:id, :start_date, :end_date]
    )
  end
end
