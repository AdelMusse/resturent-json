Rails.application.routes.draw do
  resources :foods
  resources :orders
  resources :addresses
  resources :users

  # get '/menu' => 'orders#menu'

  # getting menu
  # get '/available' => 'orders#menu'
  # sending orders
  # post '/orders' => 'orders#create'
  # checking status via order_id
  get '/orders/status' => 'orders#order_status'
# ask for deliver via order_id,User_info,Address
  post '/deliver' => 'orders#deliver'
  #checking status of deliever via order_id
  get '/deliver/status' => 'orders#deliver_status'

  post 'http://192.168.0.22:9090/api/v1/send' => 'orders#sms'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
