Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Applications routes
    resources :applications, param: :token, only: [:index, :show, :create, :update, :destroy] do
      # Chats nested routes
      resources :chats, param: :number, only: [:index, :show, :create, :update, :destroy] do

      end
    end
end
