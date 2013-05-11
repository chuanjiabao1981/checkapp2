Checkapp2::Application.routes.draw do
  


  resources :roles
  resources :tenants

  
  resources :sessions, only: [:new, :create, :destroy]
  resources :users do
    get 'track',    :on => :collection
    get 'checkin',  :on => :collection
    get 'add_track_point',:on => :collection
  end
  resources :quick_reports do
    get 'search' , :on => :collection
  end
  resources :issues,shallow:true,only:[] do
    resources :resolves,only:[:new,:create,:update,:edit]
  end
  resources :locations
  resources :organizations

  resources :templates

  resources :templates,shallow:true,only:[] do
    resources :check_points,only:[:new,:create,:update,:edit,:destroy]
  end

  resources :template_reports,only:[:index,:new,:create,:destroy,:show] do
    get 'search',:on => :collection
  end

  resources :template_reports,shallow:true,only:[] do
    resources :template_check_records,only:[:new,:create,:update,:edit,:destroy,:show]
  end
  
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  root :to => 'main#overview'


  namespace :api ,defaults: {format: 'json'} do
    namespace :v1 do
      resources :sessions, only: [:create,:destroy]
      resources :track_points, only: [:create]
      resources :organizations,only: [] do
        collection do
          get 'users',defaults:{format:'html'}
        end
      end
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
