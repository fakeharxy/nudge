Rails.application.routes.draw do
  root to: 'notes#index'
  resources :notes
  resources :tags, only: [:index, :show]
  resources :seconds, only: [:index, :show]
  devise_for :users
  # get "select", to: "notes#select"
  # get "selectValue/:id", to: "notes#selectvalue"
  get "view", to: "notes#view"
  get "noteseen/:id", to: "notes#seen", as: "noteseen"
  get "reset", to: "notes#reset", as: "reset"
  get "changeimportance", to: "tags#changeimportance", as: "changeimportance"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
