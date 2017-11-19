Rails.application.routes.draw do
  devise_for :doctors
  root 'application#index'
end
