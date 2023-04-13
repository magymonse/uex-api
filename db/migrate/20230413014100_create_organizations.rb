class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.text :address
      t.boolean :current_agreement
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phonenumber

      t.timestamps
    end
  end
end
