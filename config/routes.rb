Rails.application.routes.draw do
  get 'help/builders'

  get 'help/recipes'

  get 'help/repos'

  get 'help/builds'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :builds

  resources :builders
  get '/builders/:hostname/getwork', :to => 'builders#getwork'
  #match '/builders(/:hostname)/getwork', :action => 'getwork', via: [:get], :controller => :builders

  resources :repos

  resources :recipes
  get '/recipe/:name(/:version)', :to => 'recipes#show_byname', :format => false, :constraints => { :version => /[^\/]+/ }

  root 'recipes#index'
end
