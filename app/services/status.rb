module Status
  class Success
    def self.success?
      true
    end
  end

  class Error
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def self.success?
      false
    end

    def success?
      false
    end
  end
end
