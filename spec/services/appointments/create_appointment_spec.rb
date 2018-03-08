require_relative '../appointments_spec'

module Appointments
  RSpec.describe "Create appointment" do
    def patient_with(attrs)
      FakePatient.new(attrs)
    end

    def patients_store
      FakeStorePatient.new([
        patient_with(id: "p1", name: "Emmanuel", last_name: "Serna Sandoval")
      ])
    end

    def store
      DummyStore
    end

    def new_appointment_form(doctor_id)
      Appointments.new_appointment_form(doctor_id, patients_store)
    end

    def create_appointment(doctor_id, params)
      Appointments.create_appointment(doctor_id, params, store, patients_store)
    end

    it "has form" do
      doctor_id = rand(10)
      form = new_appointment_form(doctor_id)
      expect(form.doctor_id).to eq doctor_id
      expect(form.scheduled).to eq nil
      expect(form.patient_id).to eq nil
    end

    it "has patients options" do
      doctor_id = rand(10)
      form = new_appointment_form(doctor_id)
      expect(form.patients_options).to eq []
    end

    it "create a record" do
      doctor_id = rand(10)
      params = {
        "scheduled" => DateTime.new(2001,2,3,4,5,6),
        "patient_id" => "1"
      }
      expect(store).to receive(:create).with(
      {
        doctor_id: doctor_id,
        scheduled: DateTime.new(2001,2,3,4,5,6),
        patient_id: "1"
      })
      create_appointment(doctor_id, params)
    end

    it "returns success" do
      doctor_id = rand(10)
      params = {
        "scheduled" => DateTime.new(2001,2,3,4,5,6),
        "patient_id" => "1"
      }
      status = create_appointment(doctor_id, params)
      expect(status).to be_success
    end

    describe "with bad attributes" do
      attr_reader :doctor_id, :params
      before do
        @doctor_id = rand(10)
        @params = {
          "scheduled" => nil,
          "patient_id" => nil
        }
      end

      it "does not returns success" do
        status = create_appointment(doctor_id, params)
        expect(status).not_to be_success
      end

      it "does not create the record" do
        expect(store).not_to receive(:create)
        create_appointment(doctor_id, params)
      end

      it "returns errors" do
        errors = create_appointment(doctor_id, params).form.errors.messages

        expect(errors).to include scheduled: ["no puede estar en blanco"]
        expect(errors).to include patient_id: ["no puede estar en blanco"]
      end
    end
  end
end
