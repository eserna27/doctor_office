require_relative '../doctor_spec'

module Doctors
  RSpec.describe "List doctors patients" do
    def patient_with(attrs)
      FakePatient.new(attrs)
    end

    def patient_store_with(records)
      FakeBasicStore.new(records)
    end

    def list_doctor_patients(doctor_id, patient_store)
      Patients.list_doctor_patients(doctor_id, patient_store)
    end

    attr_reader :doctor_id, :patient_store
    before do
      @doctor_id = rand(10)
      @patient_store = patient_store_with([
        patient_with(
          id: "p1",
          name: "Emmanuel",
          last_name: "Serna Sandoval",
          gender: "m",
          email: "eserna27@gmail.com",
          doctor_id: doctor_id),
        patient_with(
          id: "p2",
          name: "Benito",
          last_name: "Serna Gonzalez",
          gender: "m",
          email: "bhsg@gmail.com",
          doctor_id: doctor_id)
      ])
    end

    it "has attributes" do
      patient1, patient2 = list_doctor_patients(doctor_id, patient_store)

      expect(patient1.id).to eq "p1"
      expect(patient1.name).to eq "Emmanuel"
      expect(patient1.last_name).to eq "Serna Sandoval"
      expect(patient1.gender).to eq "m"
      expect(patient1.email).to eq "eserna27@gmail.com"
      expect(patient1.doctor_id).to eq doctor_id

      expect(patient2.id).to eq "p2"
      expect(patient2.name).to eq "Benito"
      expect(patient2.last_name).to eq "Serna Gonzalez"
      expect(patient2.gender).to eq "m"
      expect(patient2.email).to eq "bhsg@gmail.com"
      expect(patient2.doctor_id).to eq doctor_id
    end
  end
end
