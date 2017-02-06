Rails.application.routes.draw do
  get 'challenge/home'
	
	get "challenge/level1"  

  get "challenge/level2"  

  get "challenge/level3"

  root 'challenge#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
