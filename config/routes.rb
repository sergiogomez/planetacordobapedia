ActionController::Routing::Routes.draw do |map|
  map.resources :entries, :collection => { :rss => :get }

  map.resources :feeds, :collection => { :fetch_all => :get, :fetch_next => :get, :pending => :get }, :member => { :fetch => :get, :approve => :put }
  
  map.login    '/login', :controller => 'sessions', :action => 'new'
  map.logout    '/logout', :controller => 'sessions', :action => 'destroy'
  map.resource  :session
  
  map.add_blog '/anade-tu-blog', :controller => :feeds, :action => :add
  
  map.feed_rss  '/feed', :controller => :pages, :action => :redirect_to_feedburner
  map.feed_atom '/feed/atom', :controller => :pages, :action => :redirect_to_feedburner
  
  map.page ':id',
    :controller   => 'pages',
    :action       => 'show',
    :requirements => { :id => /[a-z0-9-]+/ }
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "pages"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
