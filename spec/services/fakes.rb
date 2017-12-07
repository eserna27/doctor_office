class DummyStore
  attr_reader :all

  def initialize(records = nil)
    @all = records
  end

  def create(attrs)
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
end

class ConsultationFake
  ATTRS = [:doctor_id, :time, :patient]

  attr_reader(*ATTRS)

  def initialize(attrs)
    ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
  end
end
