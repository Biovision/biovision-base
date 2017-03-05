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

    resources :privileges, only: [:index, :show] do
      member do
        put 'lock', defaults: { format: :json }
        delete 'lock', action: :unlock, defaults: { format: :json }
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
        get 'users', defaults: { format: :json }
        put 'users/:user_id' => :add_user, as: :user, defaults: { format: :json }
        delete 'users/:user_id' => :remove_user, defaults: { format: :json }
        get 'groups'
      end
    end
    resources :privilege_groups, only: [:index, :show] do
      member do
        put 'privileges/:privilege_id' => :add_privilege, as: :privilege, defaults: { format: :json }
        delete 'privileges/:privilege_id' => :remove_privilege, defaults: { format: :json }
      end
    end
  end

  resources :agents, :browsers, except: [:index, :show]

  resources :metrics, only: [:edit, :update]

  resources :privileges, except: [:index, :new, :show]
  resources :privilege_groups, except: [:index, :show]
end
