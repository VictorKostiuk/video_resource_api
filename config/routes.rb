Rails.application.routes.draw do
  devise_for :users, path: 'users', path_prefix: "/api/v1/", path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace :api do
    namespace :v1 do
      resources :channels
      resources :posts
    end
  end
end
