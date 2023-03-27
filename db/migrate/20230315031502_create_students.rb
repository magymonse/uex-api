class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.references :person, null: false, foreign_key: true
      t.integer :hours
      t.boolean :submitted
      t.date :admission_year
      t.references :career, null: false, foreign_key: true

      t.timestamps
    end
  end
end
