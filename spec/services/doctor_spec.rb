require 'spec_helper'
require_relative '../../app/services/doctors'

module Doctors
  class DummyStore
    attr_reader :all

    def initialize(records = nil)
      @all = records
    end

    def create(attrs)
    end

    def patient_with_doctor_id(doctor_id)
      all
    end
  end

  class PatientFakeStore < DummyStore
    def patient_with_doctor_id(doctor_id)
      all
    end
  end

  class PatientFake
    ATTRS = [:doctor_id, :name, :last_name, :email, :gender]

    attr_reader(*ATTRS)

    def initialize(attrs)
      ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
    end
  end
end
