Rails.application.routes.draw do
  root 'areas#index'
  get '/areas', to: 'areas#index'
  get '/areas/search', to: 'areas#search'
end
