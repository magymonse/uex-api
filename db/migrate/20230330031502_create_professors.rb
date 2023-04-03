class CreateProfessors < ActiveRecord::Migration[7.0]
  def change
    create_table :professors do |t|
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end

    create_table :professor_careers do |t|
      t.references :professor, null: false, foreign_key: true
      t.references :career, null: false, foreign_key: true

      t.timestamps
    end
  end
end
