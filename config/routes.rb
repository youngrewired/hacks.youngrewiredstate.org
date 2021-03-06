Projects::Application.routes.draw do

  devise_for :admins, :path => 'admin', :skip => [:registrations]
  as :admin do
    get 'admin/edit' => 'admin/registrations#edit', :as => 'edit_admin_registration'
    put 'admin' => 'admin/registrations#update', :as => 'admin_registration'
  end

  namespace :admin do
    resources :events, :except => :show do
      resources :award_categories, :except => :show
      resources :projects, :except => :show
      resources :unreviewed_projects, path: 'review', only: [:index, :show] do
        member do
          post :approve
          post :reject
        end
      end
    end
    resources :tags, except: [:show, :edit, :update]

    root :to => 'root#index'
  end

  get 'events/:event_id/centres/:id' => "centres#show", :as => :event_centre
  get 'events/:event_id/projects', to: 'projects#index', as: :event_projects_list
  post 'events/:event_id/projects', to: 'projects#create', as: :event_projects

  resources :events, only: [:index,:show] do
    resources :projects, except: [:index, :destroy], path: '', path_names: { new: 'submit' }
  end

  root :to => 'events#index'

end
