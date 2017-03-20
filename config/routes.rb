Rails.application.routes.draw do

  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  scope 'u/:slug', controller: :profiles do
    get '/' => :show, as: :user_profile
  end

  namespace :admin do
    resources :agents, :browsers, only: [:index, :show] do
      member do
        post 'toggle'
        put 'lock'
        delete 'lock', action: :unlock
      end
    end

    resources :codes, only: [:index, :show]
    resources :tokens, only: [:index, :show] do
      member do
        post 'toggle'
      end
    end

    resources :editable_pages, only: [:index, :show]

    resources :metrics, only: [:index, :show]

    resources :privileges, only: [:index, :show] do
      member do
        put 'lock', defaults: { format: :json }
        delete 'lock', action: :unlock, defaults: { format: :json }
        post 'priority', defaults: { format: :json }
        post 'toggle', defaults: { format: :json }
        get 'users'
        put 'users/:user_id' => :add_user, as: :user, defaults: { format: :json }
        delete 'users/:user_id' => :remove_user, defaults: { format: :json }
      end
    end
    resources :privilege_groups, only: [:index, :show] do
      member do
        put 'privileges/:privilege_id' => :add_privilege, as: :privilege, defaults: { format: :json }
        delete 'privileges/:privilege_id' => :remove_privilege, defaults: { format: :json }
      end
    end
  end

  namespace :my do
    get '/' => 'index#index'

    resource :profile, except: [:destroy]
    resource :confirmation, :recovery, only: [:show, :create, :update]
  end

  resources :agents, :browsers, except: [:index, :show]

  resources :editable_pages, except: [:index, :show]

  resources :users, except: [:index, :show]
  resources :tokens, :codes, except: [:index, :show]

  resources :metrics, only: [:edit, :update]

  resources :privileges, except: [:index, :show]
  resources :privilege_groups, except: [:index, :show]
end
