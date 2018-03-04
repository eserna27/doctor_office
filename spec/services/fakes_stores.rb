require_relative 'fakes_records'

class DummyStore
  def self.create(params)
  end

  def self.update(id, attrs)
  end
end

class FakeBasicStore
  attr_reader :all

  def initialize(records)
    @all = records
  end

  def find(param)
    where_private("id", param).first
  end

  def find_by(params)
    key = params.keys.first.to_s
    value = params.values.first
    where_private(key, value).first
  end

  def where(params)
    key = params.keys.first.to_s
    value = params.values.first
    where_private(key, value)
  end

  private
  def where_private(key, param)
    all.select{|record| record.instance_variable_get("@#{key}") == param}
  end
end

class FakeStorePatient < FakeBasicStore
  def patient_with_doctor_id(doctor_id)
    where({doctor_id: doctor_id})
  end
end

class FakeStoreConsultation < FakeBasicStore
  def doctor_day_consultations(doctor_id:, time:)
    all.select {|record|  record.doctor_id == doctor_id && (record.time.to_date == time.to_date ) }
  end

  def patient_consultations(patient_id, doctor_id)
    all.select {|record|  record.doctor_id == doctor_id && record.patient_id == patient_id  }
  end

  def create(attrs)
    FakeConsultation.new(id: :new)
  end

  def find_consultation_for_patient_and_doctor(params)
    all.detect {|record|
      record.id == params[:id] &&
      record.doctor_id == params[:doctor_id] &&
      record.patient_id == params[:patient_id]
    }
  end

  def all_doctor_consultation_on(doctor_id, date)
    all.detect{|consultation|
      consultation.doctor_id = doctor_id &&
      consultation.time = date
    }
  end
end
