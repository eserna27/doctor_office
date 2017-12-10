require_relative '../calendar_spec'

module Calendar
  RSpec.describe "#week_view" do
    describe "when week view has consultation" do
      attr_reader :consultations, :consultation_id, :patient_id

      before do
        current_date = Date.parse('17/11/28')
        doctor_id = rand(10)
        patient_id = rand(10)
        patient = patient_with({
          id: @patient_id = patient_id,
          name: "emmanuel",
          last_name: "serna sandoval"
        })
        @consultation_id = rand(10)
        consultation = consultation_with({
          id: consultation_id,
          doctor_id: doctor_id,
          time: DateTime.parse("2017-11-27T13:00:00-06:00"),
          patient: patient,
          terminated_at: DateTime.parse("2017-11-27T13:00:00-06:00")
        })
        consultation_store = consultation_store_with([consultation])
        @consultations = Calendar.week_view(
          current_date,
          current_date,
          consultation_store,
          doctor_id
          ).current_week.first.consultations
      end

      it "has patient name" do
        expect(consultations.select{|consultation| consultation.taken? }.map(&:patient_name)).to eq ["Emmanuel"]
      end

      it "has consultation id" do
        expect(consultations.select{|consultation| consultation.taken? }.map(&:id)).to eq [consultation_id]
      end

      it "should be terminated" do
        expect(consultations.select{|consultation| consultation.taken? }.map(&:terminated?)).to eq [true]
      end

      it "has patient_id" do
        expect(consultations.select{|consultation| consultation.taken? }.map(&:patient_id)).to eq [patient_id]
      end
    end

    def consultation_store_with(records)
      ConsultationFakeStore.new(records)
    end

    def consultation_with(attrs)
      ConsultationFake.new(attrs)
    end

    def patient_with(attrs)
      PatientFake.new(attrs)
    end
  end
end
