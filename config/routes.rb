Cohorts::Application.routes.draw do
  ###############
  # Admin       #
  ###############

  namespace :admin do
    root to: 'dashboard#index'

    # Authentication
    devise_for :users, controllers: { omniauth_callbacks: 'admin/omniauth_callbacks' }

    # Pages
    resources :landing_pages, except: [:show]
    resources :static_pages, except: [:show]

    # Resources
    resources :engagements do
      resources :research_sessions, path: :sessions
    end

    resources :clients do
      resources :engagements, only: [:new]
    end

    resources :forms, only: [:index, :edit, :update] do
      collection do
        get :hidden
        get :update_from_wufoo
      end
    end

    resources :people, path: :members do
      collection do
        post ':person_id/deactivate', action: :deactivate, as: :deactivate
        post 'import_csv'
        get 'search', to: 'people#index'
      end
      resources :comments
      resources :contacts, only: [:index,:update,:create]
      resources :gift_cards
      resources :traits, only: [:create, :update, :destroy]
    end
    # TODO: It's probably safe to delete this once Wufoo callbacks are changed
    post 'people', to: 'people#create'

    resources :twilio_messages, only: [:create]

    resources :gift_cards do
      get 'needed', on: :collection
    end

    resources :comments
    resources :contacts, only: [:edit]
    resources :mailchimp_updates
    resources :submissions, except: [:destroy]
    resources :taggings, only: [:create, :destroy]
    resources :tags, except: [:show, :destroy]
    resources :traits, except: [:show, :destroy]
    resources :questions, only: [:index, :show] do
      get :choices, on: :member
    end
    resources :answers, only: [:update]
    resources :saved_searches, except: [:new, :show]
    resources :checklists
    resources :session_checklists, only: [:update]
    resources :email_messages, only: [:create]

    get 'mailchimp_export/index'
    get 'mailchimp_export/create'
    get 'mailchimp_exports/index'

    get 'taggings/create'
    post 'taggings/bulk_create'
    get 'taggings/destroy'
    get 'taggings/search'

    get 'privacy_mode', to: 'dashboard#privacy_mode', as: :privacy_mode
    get 'inbox', to: 'dashboard#inbox', as: :inbox
    get 'inbox/:person_id', to: 'dashboard#message_lookup', as: :message_lookup
  end

  ###############
  # Public      #
  ###############

  root to: 'landing_page#index'

  # Redirects
  get 'veterans/signup', to: redirect('/signup/veterans')
  get 'signup/veterans/learn-more', to: redirect('/page/veteran-feedback-faq')

  # Publicly-viewable static pages
  get 'page/:id', to: 'static_page#show', as: :static_page
  get 'signup/:tag_name', to: 'landing_page#index', as: :landing_page

  # Twilio
  post 'twilio/receive'

  # Mandrill
  resource :mandrill, controller: :mandrill, only: [:show, :create] do
    post :outbound
  end
end
