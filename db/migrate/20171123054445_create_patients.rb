class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :gender
      t.references :doctor, foreign_key: true

      t.timestamps
    end
  end
end
