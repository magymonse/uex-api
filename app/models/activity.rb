class Activity < ApplicationRecord
  belongs_to :activity_type
  belongs_to :professor
  belongs_to :organizing_organization, class_name: 'Organization', foreign_key: 'organizing_organization_id'
  belongs_to :partner_organization, class_name: 'Organization', foreign_key: 'partner_organization_id'
  has_many :activity_careers
  has_many :activity_weeks
  has_one :beneficiary_detail

  validates_uniqueness_of :name
  validates_presence_of :name, :hours

  accepts_nested_attributes_for :activity_careers, allow_destroy: true
  accepts_nested_attributes_for :beneficiary_detail, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      joins(:activity_type).where("activities.name ILIKE :search OR activity_types.name ILIKE :search", search: "%#{text}%")
    end
  end
end