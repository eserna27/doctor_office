Rails.application.routes.draw do
  devise_for :doctors

  namespace :doctor do
    resources :patients
    resources :consultations
    root 'profiles#index'
  end

  root 'site#index'
end
