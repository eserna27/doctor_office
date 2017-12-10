class Consultation < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  def self.doctor_day_consultations(doctor_id:, time:)
    where("doctor_id = :doctor_id AND time >= :start and created_at < :end",
      doctor_id: doctor_id, start: time.beginning_of_day, end: time.end_of_day)
  end

  def self.patient_consultations(patient_id, doctor_id)
    where("doctor_id = :doctor_id AND patient_id = :patient_id", doctor_id: doctor_id, patient_id: patient_id )
  end

  def self.find_consultation_for_patient_and_doctor(params)
    where("doctor_id = :doctor_id AND patient_id = :patient_id AND id = :id",
      doctor_id: params[:doctor_id], patient_id: params[:patient_id], id: params[:id] ).first
  end
end
