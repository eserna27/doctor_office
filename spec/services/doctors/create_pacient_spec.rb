require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#new_patient" do
    describe "when doctor add new patient" do
      attr_reader :form, :doctor_id

      before do
        @doctor_id = rand(10)
        attrs = {doctor_id: doctor_id}
        @form = Doctors.new_patient(attrs)
      end

      it "should have name" do
        expect(form.name).to eq nil
      end

      it "should have last name" do
        expect(form.last_name).to eq nil
      end

      it "should have gender" do
        expect(form.gender).to eq nil
      end

      it "should have email" do
        expect(form.email).to eq nil
      end

      it "should have doctor_id" do
        expect(form.doctor_id).to eq doctor_id
      end
    end
  end

  RSpec.describe "#create_patient" do
    describe "validation of empty attributes" do
      attr_reader :status, :form

      before do
        pacient_attrs = {name: "", last_name: "", email: "", gender: "", doctor_id: rand(10)}
        @status = Doctors.create_patient(pacient_attrs, pacient_store)
        @form = status.form
      end

      it "should have errors" do
        expect(status).not_to be_success
      end

      it "should have error name" do
        expect(form.errors[:name].first).to eq "no puede estar en blanco"
      end

      it "should have error last name" do
        expect(form.errors[:last_name].first).to eq "no puede estar en blanco"
      end

      it "should have error email" do
        expect(form.errors[:email].first).to eq "no puede estar en blanco"
      end

      it "should have error gender" do
        expect(form.errors[:gender].first).to eq "no puede estar en blanco"
      end
    end

    describe "when pacient attributes are good" do
      attr_reader :pacient_attrs

      before do
        @pacient_attrs = {
          name: "Emmanuel",
          last_name: "Serna Sandoval",
          email: "eserna27@gmail.com",
          gender: "m",
          doctor_id: rand(10)}
      end

      it "should have success status" do
        status = Doctors.create_patient(pacient_attrs, pacient_store)
        expect(status).to be_success
      end

      it "should call patient store" do
        pacient_store_local = pacient_store
        expect(pacient_store_local).to receive(:create).with(pacient_attrs)
        Doctors.create_patient(pacient_attrs, pacient_store_local)
      end
    end

    def pacient_store
      DummyStore.new
    end
  end
end
