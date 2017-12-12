require_relative '../patients_spec'

module Patients
  RSpec.describe "accept_or_cancel_consultation_mail" do
    attr_reader :mail_view, :consultation_id

    before do
      consultation = consultation_with({
          id: @consultation_id = rand(10),
          time: Date.parse('17/11/28 11:00'),
          confidencial_id: nil,
          patient: patient_with({
            name: "emmanuel",
            last_name: "serna sandoval",
            email: "eserna27@gmail.com"
          }),
          doctor: doctor_with({
            name: "Juan Antonio",
            last_name: "Mireles"
          })
      })
      consultation_store = consultation_store_with([consultation])
      @mail_view = Patients.accept_or_cancel_consultation_mail(consultation_id, consultation_store)
    end

    it "has patient_email" do
      expect(mail_view.patient_email).to eq "eserna27@gmail.com"
    end

    it "has consultation_time_at" do
      expect(mail_view.consultation_time_at).to eq "00:00 del 28-Noviembre-2017"
    end

    it "has a consultation_id" do
      expect(mail_view.consultation_id).to eq consultation_id
    end

    it "has a patient_name" do
      expect(mail_view.patient_name).to eq "Emmanuel Serna Sandoval"
    end

    it "has a doctor_name" do
      expect(mail_view.doctor_name).to eq "Juan Antonio Mireles"
    end

    it "has a consultation_confidencial_id" do
      expect(mail_view.consultation_confidencial_id).to eq nil
    end

    describe "consultation add uuid" do
      it "should add uuid" do
        consultation = consultation_with({
            id: consultation_id = rand(10),
            confidencial_id: nil,
            patient: patient_with({
            }),
            doctor: doctor_with({
            })
        })
        consultation_store = consultation_store_with([consultation])
        expect(consultation_store).to receive(:update)
        Patients.accept_or_cancel_consultation_mail(consultation_id, consultation_store)
      end
    end

    def patient_with(attrs)
      PatientFake.new(attrs)
    end

    def consultation_with(attrs)
      ConsultationFake.new(attrs)
    end

    def consultation_store_with(records)
      ConsultationFakeStore.new(records)
    end

    def doctor_with(attrs)
      DoctorFake.new(attrs)
    end
  end
end
