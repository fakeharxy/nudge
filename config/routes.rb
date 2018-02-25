Rails.application.routes.draw do
  root to: 'notes#index'
  resources :notes
  resources :tags, only: [:index, :show]
  devise_for :users
  get "noteseen/:id", to: "notes#seen", as: "noteseen"
  get "reset", to: "notes#reset", as: "reset"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
