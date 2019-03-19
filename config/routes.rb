Rails.application.routes.draw do
  get "/" => "sessions#new"
  get "sessions/new" => "sessions#new"
  post "sessions/create" => "sessions#create"
  delete "sessions/:user_id" => "sessions#destroy"

  get "users/new" => "users#new"
  post "users/create" => "users#create"
  get "users/:user_id" => "users#show"
  get "users/:user_id/edit" => "users#edit"
  patch "users/:user_id/update" => "users#update"
  delete "users/:user_id" => "users#destroy"

  get "secrets" => "secrets#index"
  post "secrets/:user_id/create" => "secrets#create"
  get "secrets/:secret_id/:user_id/like" => "secrets#like"
  get "secrets/:secret_id/:user_id/unlike" => "secrets#unlike"
  delete "secrets/:secret_id/:user_id/delete" => "secrets#destroy"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
