Rails.application.routes.draw do

  root 'crawls#new'
  resources :crawls, only: [:new, :create, :show]

end
