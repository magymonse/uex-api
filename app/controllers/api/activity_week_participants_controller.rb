class Api::ActitvityWeekParticipantsController < Api::BaseController
  before_action :set_activity_week_participant, only: [:create, :show, :update, :destroy]

  def create
    @activity_week_participant.save!
    render json: @activity_week_participant
  end

  def index
    activity_week_participant = ActitvityWeekParticipant.search(params).paginate(page: page, per_page: per_page)
    render json: activity_week_participants, each_serializer: ActivityTypeSerializer, meta: meta_attributes(activity_week_participants)
  end

  def meta_attributes(activity_week_participants)
    {
      per_page: per_page,
      total_pages: activity_week_participants.total_pages,
      total_objects: activity_week_participants.total_entries
    }
  end

  def show
    render json: @activity_week_participant
  end

  def update
    @activity_week_participant.update!(activity_week_participant_params)
    render json: @activity_week_participant
  end

  def destroy
    @activity_week_participant.destroy!
  end

  private
  def set_activity_week_participant
    @activity_week_participant = if params[:id]
      ActitvityWeekParticipant.find(params[:id])
    else
      ActitvityWeekParticipant.new(activity_week_participant_params)
    end
  end

  def activity_week_participant_params
    params.require(:activity_week_participant).permit(:activity_week_id, :hours, :evaluation, :person_id, :entity_type)
  end
end
