require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#update_patient" do
    describe "validation of empty attributes" do
      attr_reader :patient_attrs, :patient_id, :patient_store

      before do
        @patient_attrs = {name: "Emmanuel", last_name: "Serna",
          email: "eserna27@gmail.com", gender: "hombre", doctor_id: rand(10)}
        @patient_id = rand(10)
        @patient_store = PatientFakeStore.new([])
      end

      it "call consultation_store" do
        expect(patient_store).to receive(:update).with(patient_id, patient_attrs)
        Doctors.update_patient(patient_id, patient_attrs, patient_store)
      end
    end
  end
end
