# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'rewards#index'
  post '/calculate', to: 'rewards#calculate'
end
