Rails.application.routes.draw do
  root 'areas#index'
  get '/areas', to: 'areas#index'
  post '/areas', to: 'areas#create'
  get '/areas/search', to: 'areas#search'
  post 'areas/search', to: 'areas#form'
end
