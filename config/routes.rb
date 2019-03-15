Rails.application.routes.draw do
  root 'areas#index'
  # Areaモデルへの書き込みリクエスト
  post '/areas', to: 'areas#create'
  # zipcode検索フォームの表示
  get '/areas/search', to: 'areas#search'
  # Areaモデルへの登録フォームをレンダーさせる
  post 'areas/search', to: 'areas#form'
end
