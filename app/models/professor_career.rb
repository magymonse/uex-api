class ProfessorCareer < ApplicationRecord
  belongs_to :professor
  belongs_to :career

  delegate :name, to: :career, prefix: true
end
