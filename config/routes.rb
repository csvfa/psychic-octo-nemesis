CheerleadingCoDatabase::Application.routes.draw do
    
  resources :line_items

  resources :invoices

  resources :events

	resources :bookings do
		resources :invoices
		member do
			get 'studio_calendar', 'booking_form'
		end
	end

  resources :customers

  resources :guests

  resources :venues

  resources :opening_times

  resources :studios do
    resources :suggested_slots
    resources :availability_slots
  end

  resources :themes

  resources :coaches

  resources :cities

  # resources :managers

  get "home/index"

  resources :events_companies
  
	resources :sales_people
	
	resources :studio_events
	
	resources :instructor_events
	
	resources :payment_events
	
	resources :booking_events
	
	get '/studios/in_city_id/:id', to: 'studios#in_city_id'
    
    get '/set_filtered_regions', to: 'bookings#set_filtered_regions'

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
  root :to => 'bookings#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
