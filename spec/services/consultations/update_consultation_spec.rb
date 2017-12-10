require_relative '../consultation_spec'

module Consultations
  RSpec.describe "#update_consultation" do
    describe "when doctor update consultation" do
      attr_reader :consultation_store, :consultation_params, :consultation_id

      before do
        @consultation_id = rand(10)
        @consultation_params = {
          diagnostic: "some text here",
          prescription: "some text here",
          observations: "some text here",
          terminated_at: DateTime.now
        }
        @consultation_store = ConsultationFakeStore.new([])
      end

      it "call consultation_store" do
        expect(consultation_store).to receive(:update).with(consultation_id, consultation_params)
        Consultations.update_consultation(consultation_params.merge(consultation_id: consultation_id), consultation_store)
      end
    end
  end
end
