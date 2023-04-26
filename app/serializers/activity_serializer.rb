class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :name, :activity_type_id, :status, :address, :virtual_participation, :organizing_organization_id, :parther_organization_id, :project_link, :hours, :ods_vinculation, :institutional_program, :institutional_extension_line, :start_date, :end_date
    
  belongs_to :beneciary_detail
  belongs_to :activity_career
  belongs_to :activity_career
  has_many :activity_careers
  has_many :activity_weeks
end
