require_relative '../consultation_spec'

module Consultations
  RSpec.describe "new_consultation_with_time" do
    describe "when doctor create a consultation with time" do
      attr_reader :time, :patients, :form, :patient_id

      before do
        @time = "2017-11-27T13:00:00-06:00"
        doctor_id = rand(10)
        @patient_id = rand(10)
        patient = patient_with({
          id: patient_id,
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: doctor_id
        })
        @patients = [patient]
        patient_store = patient_store_with(patients)
        @form = Consultations.new_consultation_with_time({time: time, doctor_id: doctor_id}, patient_store)
      end

      it "has time for consultation" do
        expect(form.time).to eq time
      end

      it "has patient_id" do
        expect(form.patient_id).to eq nil
      end

      it "has a list of doctor patients options" do
        expect(form.patients_options).to eq [["Emmanuel Serna Sandoval", patient_id]]
      end

      it "has time_label" do
        expect(form.time_label).to eq "13:00"
      end

      it "has day_label" do
        expect(form.day_label).to eq "27-Noviembre-2017"
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
    describe "validate attributes" do
      attr_reader :status

      before do
        time = "2017-11-27T13:00:00-06:00"
        doctor_id = rand(10)
        patient = patient_with({
          id: rand(10),
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: doctor_id
        })
        patients = [patient]
        patient_store = patient_store_with(patients)
        params = { time: time, patient_id: "", doctor_id: doctor_id }
        consultation_store = DummyStore.new
        @status = Consultations.create_consultation(params, consultation_store, patient_store)
      end

      it "is not success" do
        expect(status).not_to be_success
      end
    end

    describe "when is create" do
      attr_reader :status

      before do
        time = "2017-11-27T13:00:00-06:00"
        doctor_id = rand(10)
        patient = patient_with({
          id: rand(10),
          name: "emmanuel",
          last_name: "serna sandoval",
          email: "eserna27@gmail.com",
          gender: "hombre",
          doctor_id: doctor_id
        })
        patients = [patient]
        patient_store = patient_store_with(patients)
        params = { time: time, patient_id: "1", doctor_id: doctor_id }
        consultation_store = ConsultationFakeStore.new([])
        @status = Consultations.create_consultation(params, consultation_store, patient_store)
      end

      it "has consultation id" do
        expect(status.consultation_id).to be_present
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
