require_relative '../patients_spec'

module Patients
  RSpec.describe "#list_consultations" do
    describe "want to view patient consultations" do
      attr_reader :consultation_view, :patient_id, :doctor_id

      before do
        @patient_id = rand(10)
        @doctor_id = rand(10)
        patient =  patient_with({id: patient_id, name: "emmanuel", last_name: "serna sandoval"})
        records = [
          consultation_with({id: :correct, patient: patient, patient_id: patient_id, doctor_id: doctor_id}),
          consultation_with({patient_id: :no_patient, doctor_id: doctor_id}),
          consultation_with({patient_id: patient_id, doctor_id: :no_doctor})
        ]
        consultation_store = consultation_store_with(records)
        patient_store = patient_store_with([patient])
        @consultation_view = Patients.list_consultations(patient_id, doctor_id, consultation_store, patient_store)
      end

      it "have a corrects consultation" do
        expect(consultation_view.list.map(&:id)).to eq [:correct]
      end

      it "has a patient_name" do
        expect(consultation_view.patient_name).to eq "Emmanuel Serna Sandoval"
      end

      it "has patient_id" do
        expect(consultation_view.patient_id).to eq patient_id
      end
    end

    describe "consultation item for list" do
      attr_reader :consultation

      before do
        patient_id = rand(10)
        doctor_id = rand(10)
        datetime = Date.parse('17/11/28')
        records = [
          consultation_with({time: Date.parse('17/11/28'),
            patient_id: patient_id, doctor_id: doctor_id, terminated_at: datetime, diagnostic: "Tos"})
        ]
        consultation_store = consultation_store_with(records)
        patient_store = patient_store_with([])
        @consultation = Patients.list_consultations(patient_id, doctor_id, consultation_store, patient_store).list.first
      end

      it "has a terminated_at" do
        expect(consultation.terminated_at).to eq "28-Noviembre-2017"
      end

      it "has a time_at" do
        expect(consultation.time_at).to eq "28-Noviembre-2017"
      end

      it "has a diagnostic" do
        expect(consultation.diagnostic).to eq "Tos"
      end
    end

    def consultation_store_with(records)
      ConsultationFakeStore.new(records)
    end

    def consultation_with(attrs)
      ConsultationFake.new(attrs)
    end

    def patient_with(attrs)
      PatientFake.new(attrs)
    end

    def patient_store_with(records)
      PatientFakeStore.new(records)
    end
  end
end
