Rails.application.routes.draw do
  get 'help/builders'
  get 'help/recipes'
  get 'help/repos'
  get 'help/builds'
  get 'help', :to => 'help#index'

  resources :builds
  resources :builders

  get '/builders/:hostname/getwork', :to => 'builders#getwork'
  post '/builders/:hostname/putwork', :to => 'builders#putwork'
  #match '/builders(/:hostname)/getwork', :action => 'getwork', via: [:get], :controller => :builders

  resources :repos
  resources :recipes, :only => [:index, :show], :id => /[A-Za-z0-9\.\-_\+~]+?/, :format => false

  root 'recipes#index'
end
