class CreateConsultations < ActiveRecord::Migration[5.1]
  def change
    create_table :consultations do |t|
      t.references :patient, foreign_key: true
      t.references :doctor, foreign_key: true
      t.datetime :time

      t.timestamps
    end
  end
end
