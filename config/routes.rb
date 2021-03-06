Rails.application.routes.draw do
  root :to => 'sessions#new'

  get 'personal_homepage/new'

  post 'personal_homepage/update_head_picture'

  post 'personal_homepage/update_name'

  post 'personal_homepage/send_im_info'

  post 'personal_homepage/read_im_info'

  post 'personal_homepage/add_tag'

  post 'personal_homepage/delete_tag'

  post 'personal_homepage/update_password'

  post 'personal_homepage/follow'

  post 'personal_homepage/unfollow'


  get 'applicants/new'

  post 'applicants/create'


  get 'sessions/new'

  post 'sessions/create'

  post 'sessions/logout'

  post 'sessions/post_tweet'

  post 'sessions/post_comment'

  post 'sessions/transmit'

  post 'sessions/thumbsup'

  post 'sessions/unthumbsup'

  post 'sessions/thumbsup_comment'

  post 'sessions/unthumbsup_comment'

  post 'sessions/add_tag'

  post 'sessions/delete_tag'

  post 'sessions/delete_tweet'

  post 'sessions/reply_comment'

  post 'sessions/reply_top_comment'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
