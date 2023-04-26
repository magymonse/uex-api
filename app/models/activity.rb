class Activity < ApplicationRecord
  belongs_to :activity_type
  belongs_to :organizing_organization, class_name: 'Organization', foreign_key: 'organizing_organization_id'
  belongs_to :partner_organization, class_name: 'Organization', foreign_key: 'partner_organization_id'
  has_many :activity_careers
  has_many :activity_weeks
  has_one :beneficiary_detail
  validates_presence_of :name, :hours

  class << self
    def search(params)
      scope = where({})
      scope = global_search(params[:search]) if params[:search]
      scope
    end

    def global_search(text)
      where("name ILIKE :search OR description ILIKE :search", search: "%#{text}%")
    end
  end
end