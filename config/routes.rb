Rails.application.routes.draw do
    get '/applications/:application_token/chats/:chat_number/messages/search', to: 'messages#search'

    # Applications routes
    resources :applications, param: :token, only: [:index, :show, :create, :update, :destroy] do
      # Chats nested routes
      resources :chats, param: :number, only: [:index, :show, :create, :update, :destroy] do
        # Messages nested routes
        resources :messages, param: :message_number, only: [:index, :show, :create, :update, :destroy]
      end
    end
end
