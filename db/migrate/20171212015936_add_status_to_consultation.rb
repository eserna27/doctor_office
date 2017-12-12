class AddStatusToConsultation < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :status, :string, default: "pending"
  end
end
