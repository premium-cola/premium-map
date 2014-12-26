# encoding: UTF-8

PremiumCola::Application.routes.draw do
  get "geocoder" => "geocoder#geocoder", format: 'json'
  get "geojson" => "geojson#geojson", format: 'json'

  # TODO: Deprecate?
  get 'maps/embed(/:display)' => 'maps#embed',
      defaults: { display: 'all' }

  root to: 'maps#embed', defaults: { display: 'all' }
end
