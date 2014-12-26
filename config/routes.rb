# encoding: UTF-8

PremiumCola::Application.routes.draw do
  devise_for :users

  get "geocoder" => "geocoder#geocoder", format: 'json'
  get "geojson" => "geojson#geojson", format: 'json'

  # TODO: Deprecate?
  get 'maps/embed(/:display)' => 'maps#embed',
      defaults: { display: 'all' }

  resource :upload do
    post 'upload'
  end
  root :to => 'welcome#index'
end
