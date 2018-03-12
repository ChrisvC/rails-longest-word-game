Rails.application.routes.draw do
  get '/', to: 'games#new', as: 'new'

  get '/score', to: 'games#score', as: 'score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end