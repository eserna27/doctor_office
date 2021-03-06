require "active_support"

module Calendar
  DAY_NAMES = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"]
  MONTHS = ["", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",
    "Septiembre", "Octubre", "Noviembre", "Diciembre"]

  def self.week_view(date, current_date, consultation_store, doctor_id)
    WeekView.new(date, current_date, consultation_store, doctor_id)
  end

  class WeekView
    attr_reader :current_week

    def initialize(date, current_date, consultation_store, doctor_id)
      @date = date
      @current_week = WeekGenerator.generate(date, current_date, consultation_store, doctor_id)
    end

    def last_week
      date.beginning_of_week - 1
    end

    def next_week
      date.end_of_week + 1
    end

    private
    attr_reader :date
  end

  class WeekGenerator
    def self.generate(date, current_date, consultation_store, doctor_id)
      first_day = date.beginning_of_week
      last_day = date.end_of_week
      (first_day..last_day).map { |day|
        consultations_day = consultation_store.doctor_day_consultations(
          {doctor_id: doctor_id, time: day})
        WeekDay.new(day, current_date, consultations_day)
      }
    end
  end

  class WeekDay
    attr_reader :day

    def initialize(day, current_date, consultations_day)
      @day = day
      @current_date = current_date
      @consultations_day = consultations_day
    end

    def consultations
      (open_date_time.to_i..closed_date_time.to_i).step(consultations_config[:average_time].to_i.minutes).
        map do |period_of_time|
          date_time = Time.at(period_of_time).to_datetime
          consultation = consultations_day.detect{|consultation| consultation.time.to_time == date_time.to_time }
          Consultation.new(date_time, current_date, consultation)
        end
    end

    def name
      Calendar::DAY_NAMES[day.strftime("%w").to_i]
    end

    def month
      Calendar::MONTHS[day.strftime("%_m").to_i]
    end

    private
    attr_reader :current_date, :consultations_day

    def consultations_config
      { open_at: "13:00", closed_at: "20:00", average_time: "20"}
    end

    def open_date_time
      DateTime.parse(day.strftime("%Y-%m-%dT#{consultations_config[:open_at]}:00,-06:00"))
    end

    def closed_date_time
      DateTime.parse(day.strftime("%Y-%m-%dT#{consultations_config[:closed_at]}:00,-06:00"))
    end
  end

  class Consultation < SimpleDelegator
    attr_reader :date_time
    delegate :id, to: :consultation

    def initialize(date_time, current_date, consultation)
      @date_time = date_time
      @current_date = current_date
      @consultation = consultation
      @patient = consultation.patient if taken?
    end

    def hour_label
      date_time.strftime("%H:%M")
    end

    def open?
      date_time > current_date
    end

    def taken?
      consultation
    end

    def patient_name
      "#{patient.name}".titleize
    end

    def badge_class
      open? ? "badge-info" : "badge-light"
    end

    def patient_id
      patient.id
    end

    def terminated?
      !!consultation.terminated_at
    end

    def status
      if consultation
        return "Pendiente" if consultation.status == "pending"
        return "Cancelada" if consultation.status == "cancel"
        return "Acceptada" if consultation.status == "accepted"
      end
    end

    def status_class
      if consultation
        return "text-warning" if consultation.status == "pending"
        return "text-danger" if consultation.status == "cancel"
        return "text-success" if consultation.status == "accepted"
      end
    end

    private
    attr_reader :current_date, :consultation, :patient
  end
end
