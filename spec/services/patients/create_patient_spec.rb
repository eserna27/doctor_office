require_relative '../patients_spec'

module Patients
  RSpec.describe "Create patient" do
    def store
      DummyStore
    end

    def create_patient_form(doctor_id)
      Patients.create_patient_form(doctor_id)
    end

    def create_patient(params)
      Patients.create_patient(params, store)
    end

    attr_reader :params
    before do
      @params = {
        "name" => "Emmanuel",
        "last_name" => "Serna Sandoval",
        "gender" => "m",
        "email" => "eserna27@gmail.com",
        "phone" => "83320161",
        "birthday" => Date.new(1991, 07, 27),
        "doctor_id" => "d1"
      }
    end

    it "has form" do
      doctor_id = rand(10)
      form = create_patient_form(doctor_id)
      expect(form.name).to eq nil
      expect(form.last_name).to eq nil
      expect(form.gender).to eq nil
      expect(form.email).to eq nil
      expect(form.phone).to eq nil
      expect(form.birthday).to eq nil
      expect(form.doctor_id).to eq doctor_id
    end

    it "creates a record" do
      expect(store).to receive(:create).with(
        {
          name: "Emmanuel",
          last_name: "Serna Sandoval",
          gender: "m",
          email: "eserna27@gmail.com",
          doctor_id: "d1",
          phone: "83320161",
          birthday: Date.new(1991, 07, 27)
        }
      )
      create_patient(params)
    end

    it "returns success" do
      status = create_patient(params)
      expect(status).to be_success
    end

    describe "with bad attributes" do
      attr_reader :params
      before do
        @params = {
          "name" => "",
          "last_name" => "",
          "gender" => "",
          "email" => "",
          "doctor_id" => "",
          "phone" => "",
          "birthday" => ""
        }
      end

      it "does not return success" do
        status = create_patient(params)
        expect(status).not_to be_success
      end

      it "does not creates a record" do
        expect(store).not_to receive(:create)
        create_patient(params)
      end

      it "return errors" do
        errors = create_patient(params).form.errors.messages

        expect(errors).to include name: ["no puede estar en blanco"]
        expect(errors).to include last_name: ["no puede estar en blanco"]
        expect(errors).to include email: ["no puede estar en blanco"]
        expect(errors).to include gender: ["no puede estar en blanco"]
        expect(errors).to include doctor_id: ["no puede estar en blanco"]
        expect(errors).to include birthday: ["no puede estar en blanco"]
        expect(errors).to include phone: ["no puede estar en blanco"]
      end
    end
  end
end
