class CreateActivityWeekParticipant < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_week_participants do |t|
      t.integer :hours
      t.string :evaluation
      t.references :activity_week, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.string :entity_type

      t.timestamps
    end
  end
end
