class Patient < ApplicationRecord
  belongs_to :doctor

  def full_name
    "#{name} #{last_name}"
  end

  def self.patient_with_doctor_id(doctor_id)
    where(doctor_id: doctor_id)
  end
end
