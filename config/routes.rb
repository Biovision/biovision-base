# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :removable_image do
    delete :image, action: :destroy_image, on: :member, defaults: { format: :json }
  end

  concern :lock do
    member do
      put :lock, defaults: { format: :json }
      delete :lock, action: :unlock, defaults: { format: :json }
    end
  end

  resources :agents, :browsers, only: %i[update destroy]

  resources :editable_pages, only: %i[update destroy]
  resources :simple_blocks, only: %i[update destroy]

  resources :users, only: %i[update destroy]
  resources :foreign_users, only: :destroy
  resources :tokens, :codes, only: %i[update destroy]

  resources :metrics, only: :update

  resources :media_folders, only: %i[update destroy]
  resources :media_files, only: %i[update destroy]

  resources :feedback_requests, only: :destroy

  resources :user_messages, only: %i[update destroy]

  scope '(:locale)', constraints: { locale: /ru|en|sv|cn/ } do
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

    scope 'u/:slug', controller: :profiles, constraints: { slug: %r{[^/]+} } do
      get '/' => :show, as: :user_profile
      put 'follow' => :follow, as: :follow_user
      delete 'follow' => :unfollow, as: nil
      put 'ban' => :ban, as: :ban_user
      delete 'ban' => :unban, as: nil
    end

    namespace :admin do
      get '/' => 'index#index'

      scope :components, controller: :components do
        get '/' => :index, as: :components
        scope ':slug' do
          get '/' => :show, as: :component
          get 'settings' => :settings, as: :component_settings
          patch 'settings' => :update_settings, as: nil
          patch 'parameters' => :update_parameter, as: :component_parameters
          get 'privileges' => :privileges, as: :component_privileges
          patch 'privileges' => :update_privileges, as: nil
          put 'administrators/:user_id' => :add_administrator, as: :component_administrators
          delete 'administrators/:user_id' => :remove_administrator, as: nil
          put 'users/:user_id/privileges/:privilege_slug' => :add_privilege, as: :component_privilege
          delete 'users/:user_id/privileges/:privilege_slug' => :remove_privilege, as: nil
        end
      end

      resources :agents, :browsers, only: %i[index show], concerns: %i[lock toggle]

      resources :codes, only: %i[index show]
      resources :tokens, only: %i[index show], concerns: :toggle

      resources :editable_pages, only: %i[index show], concerns: %i[priority toggle]
      resources :simple_blocks, only: %i[index show], concerns: :toggle

      resources :metrics, only: %i[index show] do
        member do
          get 'data', defaults: { format: :json }
        end
      end

      resources :users, only: %i[index show], concerns: :toggle do
        collection do
          get 'search', defaults: { format: :json }
        end
        member do
          get 'tokens'
          get 'codes'
          get 'privileges'
          put 'privileges/:privilege_id' => :grant_privilege, as: :privilege
          delete 'privileges/:privilege_id' => :revoke_privilege
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
      resources :media_files, only: %i[index show], concerns: :lock

      resources :feedback_requests, only: :index, concerns: :toggle

      resources :user_messages, only: %i[index show]
    end

    namespace :my do
      get '/' => 'index#index'

      resource :profile, except: :destroy, concerns: :check
      resource :confirmation, :recovery, only: %i[show create update]
      resources :tokens, only: :index, concerns: :toggle
      resources :login_attempts, only: :index
      resources :messages, only: :index do
        collection do
          get ':slug' => :user, as: :user, constraints: { slug: %r{[^/]+} }
          post ':slug' => :create, as: nil, constraints: { slug: %r{[^/]+} }
        end
      end
      resources :notifications, only: %i[index destroy] do
        put 'read', on: :member
        get 'count', on: :collection
      end
    end

    resources :agents, :browsers, except: %i[index show update destroy]

    resources :editable_pages, except: %i[index show update destroy], concerns: :check
    resources :simple_blocks, only: %i[new create edit], concerns: :check

    resources :users, except: %i[index show update destroy], concerns: :check
    resources :tokens, :codes, except: %i[index show update destroy]

    resources :metrics, only: :edit

    resources :media_folders, except: %i[index show update destroy]
    resources :media_files, except: %i[index show update destroy] do
      collection do
        post :ckeditor
        post :medium, defaults: { format: :json }
        post :medium_jquery, defaults: { format: :json }
      end
    end

    resources :feedback_requests, only: :create

    get 'oembed' => 'oembed#code'

    get ':slug' => 'fallback#show', constraints: { slug: /.+/ }
  end
end
