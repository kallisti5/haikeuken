Rails.application.routes.draw do
  resources :builds

  resources :builders
  get '/builders/:hostname/getwork', :to => 'builders#getwork'
  #match '/builders(/:hostname)/getwork', :action => 'getwork', via: [:get], :controller => :builders

  resources :repos

  resources :recipes

  root 'recipes#index'
end
