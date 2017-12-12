Rails.application.routes.draw do
  devise_for :doctors

  namespace :doctor do
    resources :patients do
      resources :consultations, only: [:show, :index], controller: :patient_consultations
    end
    resources :consultations do
      get 'attend_patient', on: :member
    end
    root 'profiles#index'
  end

  get "/cancelar_consulta/:confidencial_id" => "patient#cancel_consultation", as: "cancel_consultation"
  get "/acceptar_consulta/:confidencial_id" => "patient#accept_consultation", as: "accept_consultation"

  root 'site#index'
end
