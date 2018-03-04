module Patients
  class Form
    include ActiveModel::Model

    ATTRS = [:name, :last_name, :email, :gender, :doctor_id]

    attr_accessor(*ATTRS)
    attr_accessor :id
    validates_presence_of(*ATTRS)

    def initialize(attrs = {})
      @id = attrs["id"]
      @name = attrs["name"]
      @last_name = attrs["last_name"]
      @email = attrs["email"]
      @gender = attrs["gender"]
      @doctor_id = attrs["doctor_id"]
    end

    def self.new_for_edit(patient)
      new extract_attrs(patient)
    end

    def to_h
      ATTRS.map do |key|
        [key, send(key)]
      end.to_h
    end

    private

    def self.extract_attrs(patient)
      (ATTRS + [:id]).map do |key|
        [key.to_s, patient.send(key)]
      end.to_h
    end
  end
end
