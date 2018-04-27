Rails.application.routes.draw do
  root to: 'notes#index'
  resources :notes
  resources :completes, only: [:index, :destroy]
  resources :tags, only: [:index, :show]
  resources :seconds, only: [:index, :show]
  devise_for :users
  # get "select", to: "notes#select"
  # get "selectValue/:id", to: "notes#selectvalue"
  get "view", to: "notes#view"
  get "noteseen/:id", to: "notes#seen", as: "noteseen"
  get "sendtocomplete/:id", to: "completes#send_to_archive", as: "sendtocomplete"
  get "reset", to: "notes#reset", as: "reset"
  get "changeimportance", to: "tags#changeimportance", as: "changeimportance"
  get "clear", to: "notes#clear"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
