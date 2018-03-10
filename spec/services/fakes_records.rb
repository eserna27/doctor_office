class FakeRecord
  def initialize(attrs)
    set_instance_variables!(attrs)
    self.class.send(:attr_reader, *self.class::ATTRS)
  end

  private

  def set_instance_variables!(attrs)
    self.class::ATTRS.each do |key|
      instance_variable_set("@#{key}", attrs[key])
    end
  end
end

class FakePatient < FakeRecord
  ATTRS = [:doctor_id, :name, :last_name, :email, :gender, :id]

  def full_name
    "#{name} #{last_name}"
  end
end

class FakeConsultation < FakeRecord
  ATTRS = [:doctor_id, :time, :patient, :id, :terminated_at,
    :patient_id, :diagnostic, :prescription, :observations, :doctor, :confidencial_id]
end

class FakeDoctor < FakeRecord
  ATTRS = [:name, :last_name]
end

class FakeAppointment < FakeRecord
  ATTRS = [:id, :confidencial_id, :status]
end
