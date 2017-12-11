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

  root 'site#index'
end
