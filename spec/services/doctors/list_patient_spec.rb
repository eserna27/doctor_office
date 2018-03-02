require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#list_patients" do
    describe "list all patient by doctor" do
      attr_reader :patient_list, :doctor_id

      before do
        @doctor_id = rand(10)
        patient = patient_with({
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: doctor_id
        })
        patient_store = patient_store_with([patient])
        @patient_list = Doctors.list_patients(doctor_id, patient_store)
      end

      it "should have a list of patients" do
        expect(patient_list.map(&:name)).to eq ["emmanuel"]
        expect(patient_list.map(&:last_name)).to eq ["serna sandoval"]
        expect(patient_list.map(&:email)).to eq ["eserna27@gmail.com"]
        expect(patient_list.map(&:gender)).to eq ["hombre"]
        expect(patient_list.map(&:doctor_id)).to eq [doctor_id]
      end
    end

    def patient_store_with(records)
      FakeStorePatient.new(records)
    end

    def patient_with(attrs)
      FakePatient.new(attrs)
    end
  end
end
