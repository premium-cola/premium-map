# encoding: UTF-8

PremiumCola::Application.routes.draw do
  devise_for :users

  match "geocoder" => "geocoder#geocoder", :format => :json
  match "geojson/:type/:product/:near/:geocode" => "geojson#geojson", :constraints => { :geocode => /.*/ }, :format => :json

  resources :addresses
  resources :maps do
    collection do
      get 'kml'
      get 'embed(/:display)' => 'maps#embed', :defaults => { :display => 'all' }
    end
  end

  resource :upload do
    post 'upload'
  end
  root :to => 'welcome#index'
end
