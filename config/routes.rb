# encoding: UTF-8

PremiumCola::Application.routes.draw do
  match "geocoder" => "geocoder#geocoder", :format => :json
  match "geojson/:type/:product/:near/:geocode" => "geojson#geojson", :constraints => { :geocode => /.*/ }, :format => :json

  get 'maps/embed(/:display)' => 'maps#embed',
      defaults: { display: 'all' }


  resource :upload do
    post 'upload'
  end

  root to: 'maps#embed', defaults: { display: 'all' }
end
