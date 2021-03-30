Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources :promotions, only: %i[index show new create edit update destroy] do
    post 'generate_coupons', on: :member
    get 'search', on: :collection
  end

  resources :product_categories, only: %i[index show new create edit update destroy]

  resources :coupons, only: [] do
    post 'disable', on: :member
    post 'enable', on: :member
  end
end
