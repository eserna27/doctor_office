class AddUuidToConsultation < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :confidencial_id, :uuid
  end
end
