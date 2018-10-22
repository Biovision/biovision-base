Rails.application.routes.draw do
  resources :agents, :browsers, only: %i[update destroy]

  resources :editable_blocks, only: %i[update destroy]
  resources :editable_pages, only: %i[update destroy]
  resources :stored_values, only: %i[update destroy]

  resources :users, only: %i[update destroy]
  resources :foreign_users, only: :destroy
  resources :tokens, :codes, only: %i[update destroy]

  resources :metrics, only: :update

  resources :privileges, only: %i[update destroy]
  resources :privilege_groups, only: %i[update destroy]

  resources :media_folders, only: %i[update destroy]
  resources :media_files, only: %i[update destroy]

  resources :feedback_requests, only: :destroy

  resources :link_blocks, :link_block_items, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en|sv/ } do
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
      get 'contact' => :contact
    end

    scope 'u/:slug', controller: :profiles, constraints: { slug: /[^\/]+/ } do
      get '/' => :show, as: :user_profile
    end

    namespace :admin do
      get '/' => 'index#index'

      resources :agents, :browsers, only: %i[index show] do
        member do
          post 'toggle', defaults: { format: :json }
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
        end
      end

      resources :codes, only: %i[index show]
      resources :tokens, only: %i[index show] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end

      resources :editable_pages, only: %i[index show] do
        member do
          post 'priority', defaults: { format: :json }
        end
      end
      resources :editable_blocks, only: %i[index show] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :stored_values, only: %i[index show]

      resources :metrics, only: %i[index show] do
        member do
          get 'data', defaults: { format: :json }
        end
      end

      resources :privileges, only: %i[index show] do
        collection do
          post 'check'
        end
        member do
          post 'priority', defaults: { format: :json }
          post 'toggle', defaults: { format: :json }
          get 'users'
          get 'regions', defaults: { format: :json }
        end
      end
      resources :privilege_groups, only: %i[index show] do
        collection do
          post 'check'
        end
        member do
          put 'privileges/:privilege_id' => :add_privilege, as: :privilege, defaults: { format: :json }
          delete 'privileges/:privilege_id' => :remove_privilege, defaults: { format: :json }
        end
      end

      resources :users, only: %i[index show] do
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

      resources :foreign_users, only: %i[index show]

      resources :login_attempts, only: :index

      resources :media_folders, only: %i[index show] do
        member do
          get 'files'
        end
      end
      resources :media_files, only: %i[index show] do
        member do
          put 'lock', defaults: { format: :json }
          delete 'lock', action: :unlock, defaults: { format: :json }
        end
      end

      resources :feedback_requests, only: :index do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end

      resources :link_blocks, only: %i[index show] do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :link_block_items, only: :show do
        member do
          post 'toggle', defaults: { format: :json }
          post 'priority', defaults: { format: :json }
        end
      end
    end

    namespace :my do
      get '/' => 'index#index'

      resource :profile, except: :destroy do
        post 'check'
      end
      resource :confirmation, :recovery, only: %i[show create update]
      resources :tokens, only: :index do
        member do
          post 'toggle', defaults: { format: :json }
        end
      end
      resources :login_attempts, only: :index
    end

    resources :agents, :browsers, except: %i[index show update destroy]

    resources :editable_pages, except: %i[index show update destroy]
    resources :editable_blocks, except: %i[index show update destroy] do
      collection do
        post 'check', defaults: { format: :json }
      end
    end
    resources :stored_values, except: %i[index show update destroy]

    resources :link_blocks, :link_block_items, except: %i[index show update destroy] do
      collection do
        post 'check', defaults: { format: :json }
      end
    end

    resources :users, except: %i[index show update destroy] do
      collection do
        post 'check', defaults: { format: :json }
      end
    end
    resources :tokens, :codes, except: %i[index show update destroy]

    resources :metrics, only: :edit

    resources :privileges, except: %i[index show update destroy]
    resources :privilege_groups, except: %i[index show update destroy]

    resources :media_folders, except: %i[index show update destroy]
    resources :media_files, except: %i[index show update destroy] do
      collection do
        post :ckeditor
        post :medium, defaults: { format: :json }
        post :medium_jquery, defaults: { format: :json }
      end
    end

    resources :feedback_requests, only: :create

    get ':slug' => 'fallback#show', constraints: { slug: /.+/ }
  end
end
