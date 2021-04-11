Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
    get 'search', on: :collection
  end

  resources :product_categories, only: %i[index show new create edit update destroy]

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'enable', on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :coupons, only: %i[show], param: :code
      resources :promotions, only: %i[index show create], param: :code
    end
  end
end
