require_relative '../consultation_spec'

module Consultations
  RSpec.describe "#attend_patient" do
    describe "when doctor want to attend a patient" do
      attr_reader :attend_form, :consultation_id, :patient_id

      before do
        @consultation_id = rand(10)
        patient = patient_with({id: @patient_id = rand(10), name: "emmanuel", last_name: "serna sandoval"})
        consultation = consultation_with({id: consultation_id, patient: patient})
        consultation_store = consultation_store_with([consultation])
        @attend_form = Consultations.attend_patient(consultation_id, consultation_store)
      end

      it "has a observations" do
        expect(attend_form.observations).to eq nil
      end

      it "has a diagnostic" do
        expect(attend_form.diagnostic).to eq nil
      end

      it "has a prescription" do
        expect(attend_form.prescription).to eq nil
      end

      it "has patient name" do
        expect(attend_form.patient_name).to eq "Emmanuel Serna Sandoval"
      end

      it "has consultation id" do
        expect(attend_form.consultation_id).to eq consultation_id
      end

      it "has patient_id" do
        expect(attend_form.patient_id).to eq patient_id
      end
    end

    def consultation_store_with(records)
      FakeStoreConsultation.new(records)
    end

    def consultation_with(attrs)
      FakeConsultation.new(attrs)
    end

    def patient_with(attrs)
      FakePatient.new(attrs)
    end
  end
end
