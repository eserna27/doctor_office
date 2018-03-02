require_relative '../doctor_spec'

module Doctors
  RSpec.describe "#day_of_work" do
    def consultation_store_with(records)
      FakeStoreConsultation.new(records)
    end
    example "doctor see all the consultations" do
      date = Date.parse('17/11/28')
      consultation_store = consultation_store_with([])
      doctor_id = rand(10)
      calendar_generator = Calendar
      day_of_work = Doctors.day_of_work(doctor_id, date, consultation_store, calendar_generator)

      expect(day_of_work.title).to eq ""
      expect(day_of_work.consultations).to eq []
    end
  end
end
