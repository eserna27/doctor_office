module Status
  class Success
    def success?
      true
    end
  end

  class Error
    attr_reader :form

    def initialize(form)
      @form = form
    end

    def success?
      false
    end
  end
end
