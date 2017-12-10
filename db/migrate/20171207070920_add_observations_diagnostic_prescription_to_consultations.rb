class AddObservationsDiagnosticPrescriptionToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :observations, :text
    add_column :consultations, :diagnostic, :text
    add_column :consultations, :prescription, :text
  end
end
