Rails.application.routes.draw do
  root "homes#top"
  resources :users,only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  get 'confirm_email/:token', to: 'users#confirm_email', as: 'confirm_email'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :boards, only: %i[index new create show]
end
