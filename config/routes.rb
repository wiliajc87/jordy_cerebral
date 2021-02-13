Rails.application.routes.draw do
  root 'users#new'
  resources :users,    only: %i[new show create]
  resources :payments, only: %i[create destroy]
end
