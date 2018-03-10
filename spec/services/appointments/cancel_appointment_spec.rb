require_relative '../appointments_spec'

module Appointments
  RSpec.describe "Cancel appointment" do
    def store(records)
      FakeBasicStore.new(records)
    end

    def appointment_with(attr)
      FakeAppointment.new(attr)
    end

    def cancel_appointment(appointment_id, confidencial_id, appointment_store)
      Appointments.cancel(appointment_id, confidencial_id, appointment_store)
    end

    attr_reader :appointment_id, :confidencial_id, :appointment_store
    before do
      @appointment_id = rand(10)
      @confidencial_id = rand(10)
      appointment = appointment_with(appointment_id: appointment_id, confidencial_id: confidencial_id)
      @appointment_store = store([appointment])
    end

    it "updates the record" do
      expect(appointment_store).to receive(:update).with(appointment_id, {status: :canceled})
      cancel_appointment(appointment_id, confidencial_id, appointment_store)
    end

    it "returns success" do
      status = cancel_appointment(appointment_id, confidencial_id, appointment_store)
      expect(status).to be_success
    end

    describe "with bad params" do
      attr_reader :appointment_id, :appointment_store, :confidencial_id
      before do
        @appointment_id = rand(10)
        @confidencial_id = rand(10)
        @appointment_store = store([])
      end

      it "does not updates the record" do
        expect(appointment_store).not_to receive(:update)
        cancel_appointment(appointment_id, confidencial_id, appointment_store)
      end

      it "does not returns success" do
        status = cancel_appointment(appointment_id, confidencial_id, appointment_store)
        expect(status).not_to be_success
      end
    end
  end
end
