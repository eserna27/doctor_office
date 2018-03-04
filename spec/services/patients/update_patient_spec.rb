require_relative '../patients_spec'

module Patients
  RSpec.describe "Update patient" do
    def store
      DummyStore
    end

    def patient_store_with(records)
      FakeBasicStore.new(records)
    end

    def patient_with(attrs)
      FakePatient.new(attrs)
    end

    def update_patient_form(patient_id, patient_store)
      Patients.update_patient_form(patient_id, patient_store)
    end

    def update_patient(patient_id, params)
      Patients.update_patient(patient_id, params, store)
    end

    attr_reader :patient_id, :patient_store
    before do
      @patient_id = rand(10)
      @patient_store = patient_store_with([
        patient_with(
          id: patient_id,
          name: "Emmanuel",
          last_name: "Serna Sandoval",
          gender: "m",
          email: "eserna27@gmail.com",
          doctor_id: "d1")
      ])
    end

    it "has form" do
      form = update_patient_form(patient_id, patient_store)
      expect(form.id).to eq patient_id
      expect(form.name).to eq "Emmanuel"
      expect(form.last_name).to eq "Serna Sandoval"
      expect(form.gender).to eq "m"
      expect(form.email).to eq "eserna27@gmail.com"
      expect(form.doctor_id).to eq "d1"
    end

    it "updates the record" do
      patient_id = rand(10)
      params = {
        "name" => "Emmanuel",
        "last_name" => "Serna Sandoval",
        "gender" => "m",
        "email" => "eserna@gmail.com",
        "doctor_id" => "d1"
      }
      expect(store).to receive(:update).with(patient_id,
        {
          name: "Emmanuel",
          last_name: "Serna Sandoval",
          gender: "m",
          email: "eserna@gmail.com",
          doctor_id: "d1"
        }
      )
      update_patient(patient_id, params)
    end

    it "returns success" do
      patient_id = rand(10)
      params = {
        "name" => "Emmanuel",
        "last_name" => "Serna Sandoval",
        "gender" => "m",
        "email" => "eserna@gmail.com",
        "doctor_id" => "d1"
      }
      status = update_patient(patient_id, params)
      expect(status).to be_success
    end

    describe "with bad attributes" do
      attr_reader :params, :patient_id
      before do
        @patient_id = rand(10)
        @params = {
          "name" => "",
          "last_name" => "",
          "gender" => "",
          "email" => "",
          "doctor_id" => ""
        }
      end

      it "does not return success" do
        status = update_patient(patient_id, params)
        expect(status).not_to be_success
      end

      it "does not update a record" do
        expect(store).not_to receive(:update)
        update_patient(patient_id, params)
      end

      it "return errors" do
        errors = update_patient(patient_id, params).form.errors.messages

        expect(errors).to include name: ["no puede estar en blanco"]
        expect(errors).to include last_name: ["no puede estar en blanco"]
        expect(errors).to include email: ["no puede estar en blanco"]
        expect(errors).to include gender: ["no puede estar en blanco"]
        expect(errors).to include doctor_id: ["no puede estar en blanco"]
      end
    end
  end
end
