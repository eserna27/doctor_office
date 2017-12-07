require 'spec_helper'
require_relative '../../app/services/calendar'
require_relative 'fakes'

module Calendar
  RSpec.describe "#week_view" do
    describe "recive the current week" do
      attr_reader :week_view, :current_date

      before do
        @current_date = Date.parse('17/11/28')
        consultation_store = consultation_store_with([])
        @week_view = Calendar.week_view(
          current_date,
          current_date,
          consultation_store,
          :no_doctor_id
        )
      end

      it "has 7 days" do
        expect(week_view.current_week.count).to eq 7
      end

      it "has call to last week" do
        expect(week_view.last_week).to eq (current_date.beginning_of_week - 1)
      end

      it "has call to next week" do
        expect(week_view.next_week).to eq (current_date.end_of_week + 1)
      end
    end

    describe "a day options" do
      attr_reader :day_view, :current_week

      before do
        current_date = Date.parse('17/11/28')
        consultation_store = consultation_store_with([])
        @current_week = Calendar.week_view(
          current_date,
          current_date,
          consultation_store,
          :no_doctor_id
        ).current_week
        @day_view = current_week.first
      end

      it "has consultations" do
        expect(day_view.consultations.count).to be 22
      end

      it "has number of day and month" do
        expect(day_view.day.to_s).to eq "2017-11-27"
      end

      it "has day name" do
        expect(current_week.map(&:name)).to eq ["Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado", "Domingo"]
      end

      it "has months" do
        expect(current_week.map(&:month)).to eq ["Noviembre", "Noviembre",
          "Noviembre", "Noviembre", "Diciembre", "Diciembre", "Diciembre"]
      end
    end

    describe "a consultation" do
      attr_reader :consultations, :current_date

      before do
        @current_date = Date.parse('17/11/28')
        consultation_store = consultation_store_with([])
        @consultations = Calendar.week_view(
          current_date,
          current_date,
          consultation_store,
          :no_doctor_id
        ).current_week.first.consultations
      end

      it "has hour_label" do
        expect(consultations.map(&:hour_label)).to eq ["13:00",
          "13:20", "13:40", "14:00", "14:20", "14:40", "15:00",
          "15:20", "15:40", "16:00", "16:20", "16:40", "17:00",
          "17:20", "17:40", "18:00", "18:20", "18:40", "19:00",
          "19:20", "19:40", "20:00"]
      end

      it "has datetime" do
        expect(consultations.first.date_time.to_s).to eq "2017-11-27T13:00:00-06:00"
      end

      it "is open if not to past the current day" do
        expect(consultations.first.open?).to eq false
      end
    end

    def consultation_store_with(records)
      ConsultationFakeStore.new(records)
    end
  end
end
