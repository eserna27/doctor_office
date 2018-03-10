require_relative '../consultation_spec'

module Consultations
  RSpec.describe "#update_consultation" do
    describe "when doctor update consultation" do
      def store
        DummyStore
      end

      def update_consultation(params)
        Consultations.update_consultation(params, store)
      end

      it "call consultation_store" do
        consultation_id = rand(10)
        params = {
          diagnostic: "some text here",
          prescription: "some text here",
          observations: "some text here",
          terminated_at: DateTime.now
        }
        expect(store).to receive(:update).with(consultation_id, params)
        update_consultation(params.merge(consultation_id: consultation_id))
      end
    end
  end
end
