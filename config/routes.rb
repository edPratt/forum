Rails.application.routes.draw do  
  root to: 'home#show'
  scope path: 'admin' do
    authenticate :user, lambda { |u| u.admin? } do
      mount RailsEmailPreview::Engine, at: 'emails'
    end
  end
  

  devise_for :users,
           skip: %i[sessions],
           controllers: {
             registrations: 'users/registrations',
             sessions: 'users/sessions',
           },
           path_names: { sign_up: 'register' }
devise_scope :user do
  get 'sign-in', to: 'users/sessions#new', as: :new_user_session
  post 'sign-in', to: 'users/sessions#create', as: :user_session
  match 'sign-out', to: 'users/sessions#destroy', as: :destroy_user_session,
                    via: Devise.mappings[:user].sign_out_via
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show]
  mount Thredded::Engine => '/forum'
end
