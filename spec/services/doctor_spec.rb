require 'spec_helper'
require_relative '../../app/services/doctors'

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
        user_attrs = {name: "", last_name: "", email: "", gender: "", doctor_id: rand(10)}
        @status = Doctors.create_patient(user_attrs, user_store)
        @form = status.form
      end

      it "should have errors" do
        expect(status).not_to be_success
      end

      it "should have error name" do
        expect(form.errors[:name].first).to eq "can't be blank"
      end

      it "should have error last name" do
        expect(form.errors[:last_name].first).to eq "can't be blank"
      end

      it "should have error email" do
        expect(form.errors[:email].first).to eq "can't be blank"
      end

      it "should have error gender" do
        expect(form.errors[:gender].first).to eq "can't be blank"
      end
    end

    def user_store
      DummyStore.new
    end
  end

  class DummyStore
    def self.create(attrs)

    end
  end
end
