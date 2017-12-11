class DummyStore
  attr_reader :all

  def initialize(records = nil)
    @all = records
  end

  def create(attrs)
  end

  def update(id, attrs)
  end

  def find(id)
    all.detect { |record| record.id == id }
  end

  def where(attr)
    all.select { |record|  record.instance_variable_get("@#{attr.keys.first}") == attr.values.first }
  end
end

class PatientFakeStore < DummyStore
  def patient_with_doctor_id(doctor_id)
    where({doctor_id: doctor_id})
  end
end

class PatientFake
  ATTRS = [:doctor_id, :name, :last_name, :email, :gender, :id]

  attr_reader(*ATTRS)

  def initialize(attrs)
    ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
  end
end

class ConsultationFakeStore < DummyStore
  def doctor_day_consultations(doctor_id:, time:)
    all.select {|record|  record.doctor_id == doctor_id && (record.time.to_date == time.to_date ) }
  end

  def patient_consultations(patient_id, doctor_id)
    all.select {|record|  record.doctor_id == doctor_id && record.patient_id == patient_id  }
  end

  def create(attrs)
    ConsultationFake.new(id: :new)
  end

  def find_consultation_for_patient_and_doctor(params)
    all.detect {|record|
      record.id == params[:id] &&
      record.doctor_id == params[:doctor_id] &&
      record.patient_id == params[:patient_id]  }
  end
end

class ConsultationFake
  ATTRS = [:doctor_id, :time, :patient, :id, :terminated_at,
    :patient_id, :diagnostic, :prescription, :observations, :doctor]

  attr_reader(*ATTRS)

  def initialize(attrs)
    ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
  end
end

class DoctorFake
  ATTRS = [:name, :last_name]

  attr_reader(*ATTRS)

  def initialize(attrs)
    ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
  end
end
