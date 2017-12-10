class AddTerminatedAtToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :terminated_at, :datetime, default: nil
  end
end
