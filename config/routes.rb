Rails.application.routes.draw do
  namespace :admin do
    resources :agents, :browsers, only: [:index, :show] do
      member do
        post 'toggle'
        put 'lock'
        delete 'lock', action: :unlock
      end
    end

    resources :metrics, only: [:index, :show]
  end

  resources :agents, :browsers, except: [:index, :show]
  resources :metrics, only: [:edit, :update]
end
