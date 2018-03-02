require_relative '../consultation_spec'

module Consultations
  RSpec.describe "#show_consultation" do
    describe "when want to view a consultation" do
      attr_reader :consultation, :patient_id

      before do
        params = {
          id: consultation_id = rand(10),
          patient_id: @patient_id = rand(10),
          doctor_id: doctor_id = rand(10)
        }
        consultation_record = consultation_with(params.merge({prescription: "", diagnostic: "", observations: ""}))
        consultation_store = consultation_store_with([consultation_record])
        @consultation = Consultations.show_consultation(params, consultation_store)
      end

      it "has observations" do
        expect(consultation.observations).to eq ""
      end

      it "has diagnostic" do
        expect(consultation.diagnostic).to eq ""
      end

      it "has observations" do
        expect(consultation.prescription).to eq ""
      end

      it "has patient_id" do
        expect(consultation.patient_id).to eq patient_id
      end
    end

    def consultation_with(attrs)
      FakeConsultation.new(attrs)
    end

    def consultation_store_with(records)
      FakeStoreConsultation.new(records)
    end
  end
end
