Rails.application.routes.draw do
  get 'search/pick'
  get 'search/index'
  get 'welcome/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/index'
 
  root 'welcome#index'
end
