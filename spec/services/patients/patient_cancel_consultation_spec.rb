require_relative '../patients_spec'

module Patients
  RSpec.describe "#cancel_consultation" do
    it "should change update status to cancel" do
      consultation = ConsultationFake.new({
          id: consultation_id = rand(10),
          confidencial_id: consultation_id
      })
      consultation_store = ConsultationFakeStore.new([consultation])
      params = {confidencial_id: consultation_id}
      expect(consultation_store).to receive(:update).with(consultation_id, status: :cancel)
      Patients.cancel_consultation(params, consultation_store)
    end

    it "should has status success" do
      consultation = ConsultationFake.new({
          id: consultation_id = rand(10),
          confidencial_id: consultation_id
      })
      consultation_store = ConsultationFakeStore.new([consultation])
      params = {confidencial_id: consultation_id}
      status = Patients.cancel_consultation(params, consultation_store)
      expect(status.status).to eq :success
    end

    it "should has status error" do
      consultation = ConsultationFake.new({
          id: consultation_id = rand(10),
          confidencial_id: nil
      })
      consultation_store = ConsultationFakeStore.new([consultation])
      params = {confidencial_id: consultation_id}
      status = Patients.cancel_consultation(params, consultation_store)
      expect(status.status).to eq :error
    end
  end
end
