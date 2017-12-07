class Consultation < ApplicationRecord
  belongs_to :patient
  belongs_to :doctor

  def self.doctor_day_consultations(doctor_id:, time:)
    where("doctor_id = :doctor_id AND time >= :start and created_at < :end",
      doctor_id: doctor_id, start: time.beginning_of_day, end: time.end_of_day)
  end
end
