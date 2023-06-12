class Activity < ApplicationRecord
  belongs_to :activity_type
  belongs_to :professor
  belongs_to :organizing_organization, class_name: 'Organization', foreign_key: 'organizing_organization_id'
  belongs_to :partner_organization, class_name: 'Organization', foreign_key: 'partner_organization_id'
  has_many :activity_careers, dependent: :destroy
  has_many :careers, through: :activity_careers
  has_many :activity_weeks, dependent: :destroy
  has_one :beneficiary_detail, dependent: :destroy

  validates_uniqueness_of :name
  validates_presence_of :name, :hours

  accepts_nested_attributes_for :activity_careers, allow_destroy: true
  accepts_nested_attributes_for :beneficiary_detail, allow_destroy: true

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search] if params[:search].present?
      scope = scope.joins(:careers).where(careers: params[:career_id]) if params[:career_id].present?
      scope
    end

    def global_search(text)
      joins(:activity_type, professor: :person)
        .where(
          "activities.name ILIKE :search OR activity_types.name ILIKE :search OR CONCAT_WS(' ', first_name, last_name) ILIKE :search",
          search: "%#{text}%"
        )
    end
  end
end