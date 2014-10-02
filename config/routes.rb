Rails.application.routes.draw do
  resources :builds

  resources :builders
  get '/builders/:hostname/getwork', :to => 'builders#getwork'
  #match '/builders(/:hostname)/getwork', :action => 'getwork', via: [:get], :controller => :builders

  resources :repos

  resources :recipes
  get '/recipe/:name(/:version)', :to => 'recipes#show_byname', :format => false, :constraints => { :version => /[^\/]+/ }

  root 'recipes#index'
end
