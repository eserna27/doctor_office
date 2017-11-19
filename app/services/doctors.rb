require "active_model"

module Doctors
  def self.new_patient(attrs)
    Form.new(attrs)
  end

  def self.create_patient(attrs, pacient_store)
    form = Form.new(attrs)
    if form.valid?
      pacient_store.create(form.to_h)
      SuccessStatus.new
    else
      ErrorStatus.new(form)
    end
  end

  class Form
    include ActiveModel::Model

    ATTRS = [:name, :last_name, :email, :gender, :doctor_id]

    attr_accessor(*ATTRS)
    validates_presence_of(*ATTRS)

    def initialize(attrs)
       ATTRS.map{|key| instance_variable_set("@#{key}", attrs[key])}
    end

    def to_h
      ATTRS.map{|attr| [attr, send(attr)]}.to_h
    end
  end

  class SuccessStatus
    def success?
      true
    end
  end

  class ErrorStatus
    attr_reader :form
    def initialize(form)
      @form = form
    end

    def success?
      false
    end
  end
end
