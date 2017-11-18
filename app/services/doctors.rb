require "active_model"

module Doctors
  def self.new_patient(attrs)
    Form.new(attrs)
  end

  def self.create_patient(attrs, user_store)
    form = Form.new(attrs)
    if form.valid?
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
