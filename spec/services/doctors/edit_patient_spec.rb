require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#edit_patient" do
    describe "when doctor want to edit patient" do
      attr_reader :form, :patient_id

      before do
        @patient_id = rand(10)
        patient = patient_with({
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          id: patient_id
        })
        patient_store = patient_store_with([patient])
        @form = Doctors.edit_patient(patient_id, patient_store)
      end

      it "has patien id" do
        expect(form.id).to eq patient_id
      end

      it "has patient name" do
        expect(form.name).to eq "emmanuel"
      end

      it "has patient last_name" do
        expect(form.last_name).to eq "serna sandoval"
      end

      it "has patien email" do
        expect(form.email).to eq "eserna27@gmail.com"
      end

      it "has patien gender" do
        expect(form.gender).to eq "hombre"
      end
    end

    def patient_store_with(records)
      PatientFakeStore.new(records)
    end

    def patient_with(attrs)
      PatientFake.new(attrs)
    end
  end
end
