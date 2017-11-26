require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#new_consultatio" do
    describe "when doctor create a consultation for patient" do
      attr_reader :form, :doctor_id, :patients

      before do
        @doctor_id = rand(10)
        @patients = [patient_with({
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: doctor_id
        })]
        patient_store = patient_store_with(patients)
        @patient_list = Doctors.list_patients(doctor_id, patient_store)
        @form = Doctors.new_consultation(doctor_id, patient_store)
      end

      it "has patient id" do
        expect(form.patient_id).to eq nil
      end

      it "has doctor id" do
        expect(form.doctor_id).to eq nil
      end

      it "has patients options" do
        expect(form.patients_options).to eq patients
      end

      it "has datetime" do
        expect(form.datetieme).to eq nil
      end
    end

    def patient_store_with(records)
      PatientFakeStore.new(records)
    end

    def patient_with(attrs)
      PatientFake.new(attrs)
    end
  end

  RSpec.describe "#create_consultation" do
    describe "when attributes has errors" do
      attr_reader :status, :form, :patients

      before do
        @patients = [patient_with({
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: rand(10)
        })]
        patient_store = patient_store_with(patients)
        consultation_attrs = {patient_id: "", doctor_id: "", datetieme: ""}
        @status = Doctors.create_consultation(consultation_attrs, patient_store, DummyStore.new)
        @form = status.form
      end


      it "has not be success" do
        expect(status).not_to be_success
      end

      it "has patients options" do
        expect(form.patients_options).to eq patients
      end
    end

    describe "when attributes are correct" do
      attr_reader :patient_store, :consultation_attrs

      before do
        @patient_store = patient_store_with([])
        @consultation_attrs = {
          patient_id: rand(10),
          doctor_id: rand(10),
          datetieme: DateTime.new
        }
      end

      it "has to be success" do
        status = Doctors.create_consultation(consultation_attrs, patient_store, DummyStore.new)
        expect(status).to be_success
      end

      it "should call consultation store" do
        consultation_store = DummyStore.new
        expect(consultation_store).to receive(:create).with(consultation_attrs)
        Doctors.create_consultation(consultation_attrs, patient_store, consultation_store)
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
