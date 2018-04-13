Rails.application.routes.draw do
  resources :agents, :browsers, only: [:update, :destroy]

  resources :editable_pages, only: [:update, :destroy]
  resources :stored_values, only: [:update, :destroy]

  resources :users, only: [:update, :destroy]
  resources :tokens, :codes, only: [:update, :destroy]

  resources :metrics, only: [:update]

  resources :privileges, only: [:update, :destroy]
  resources :privilege_groups, only: [:update, :destroy]

  resources :media_folders, only: [:update, :destroy]
  resources :media_files, only: [:update, :destroy]

  resources :feedback_requests, only: [:destroy]

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    # Handling errors
    match '/400' => 'errors#bad_request', via: :all
    match '/401' => 'errors#unauthorized', via: :all
    match '/403' => 'errors#forbidden', via: :all
    match '/404' => 'errors#not_found', via: :all
    match '/422' => 'errors#unprocessable_entity', via: :all
    match '/500' => 'errors#internal_server_error', via: :all

    controller :authentication do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
      get 'auth/:provider/callback' => :auth_callback, as: :auth_callback
    end

    controller :about do
      get 'about' => :index
      get 'tos' => :tos
      get 'privacy' => :privacy
    end

    scope 'u/:slug', controller: :profiles, constraints: { slug: /[^\/]+/ } do
      get '/' => :show, as: :user_profile
    end

    namespace :admin do
      get '/' => 'index#index'

      resources :agents, :browsers, only: [:index, :show] do
        member do
          post 'toggle', defaults: { format: :json }
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
        end
      end

      resources :codes, only: [:index, :show]
      resources :tokens, only: [:index, :show] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end

      resources :editable_pages, only: [:index, :show]
      resources :stored_values, only: [:index, :show]

      resources :metrics, only: [:index, :show] do
        member do
          get 'data', defaults: { format: :json }
        end
      end

      resources :privileges, only: [:index, :show] do
        member do
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
          post 'priority', defaults: { format: :json }
          post 'toggle', defaults: { format: :json }
          get 'users'
          get 'regions', defaults: { format: :json }
        end
      end
      resources :privilege_groups, only: [:index, :show] do
        member do
          put 'privileges/:privilege_id' => :add_privilege, as: :privilege, defaults: { format: :json }
          delete 'privileges/:privilege_id' => :remove_privilege, defaults: { format: :json }
        end
      end

      resources :users, only: [:index, :show] do
        collection do
          get 'search', defaults: { format: :json }
        end
        member do
          get 'tokens'
          get 'codes'
          get 'privileges'
          put 'privileges/:privilege_id' => :grant_privilege, as: :privilege
          delete 'privileges/:privilege_id' => :revoke_privilege
          post 'toggle', defaults: { format: :json }
          post 'authenticate'
        end
      end

      resources :login_attempts, only: [:index]

      resources :media_folders, only: [:index, :show] do
        member do
          get 'files'
        end
      end
      resources :media_files, only: [:index, :show] do
        member do
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
        end
      end

      resources :feedback_requests, only: [:index] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
    end

    namespace :my do
      get '/' => 'index#index'

      resource :profile, except: [:destroy]
      resource :confirmation, :recovery, only: [:show, :create, :update]
      resources :tokens, only: [:index] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :login_attempts, only: [:index]
    end

    resources :agents, :browsers, except: [:index, :show, :update, :destroy]

    resources :editable_pages, except: [:index, :show, :update, :destroy]
    resources :stored_values, except: [:index, :show, :update, :destroy]

    resources :users, except: [:index, :show, :update, :destroy] do
      collection do
        post 'check', defaults: { format: :json }
      end
    end
    resources :tokens, :codes, except: [:index, :show, :update, :destroy]

    resources :metrics, only: [:edit]

    resources :privileges, except: [:index, :show, :update, :destroy]
    resources :privilege_groups, except: [:index, :show, :update, :destroy]

    resources :media_folders, except: [:index, :show, :update, :destroy]
    resources :media_files, except: [:index, :show, :update, :destroy] do
      collection do
        post :ckeditor
      end
    end

    resources :feedback_requests, only: [:create]
  end
end
