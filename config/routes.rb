# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: { format: :json } do
    resources :available_time_slots, only: %i[index]
    resources :booked_time_slots, only: %i[create]
  end
end
