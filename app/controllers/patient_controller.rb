class PatientController < ActionController::Base
  def cancel_consultation
    @status = Patients.cancel_consultation({confidencial_id: params[:confidencial_id]}, Consultation).status
  end

  def accept_consultation
    @status = Patients.accept_consultation({confidencial_id: params[:confidencial_id]}, Consultation).status
  end
end
