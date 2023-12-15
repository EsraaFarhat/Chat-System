
class ChatsController < ApplicationController
    before_action :set_application
    before_action :set_chat, only: [:show, :update, :destroy]
  
    def index
      @chats = @application.chats.order("created_at desc").all
      render json: @chats.as_json(except: [:id, :application_id])
    end
  
    def show
        render json: @chat.as_json(except: [:id, :application_id])
    end
  
    def create
        chat_number = @application.next_chat_number

        if chat_number.present?
          @chat = @application.chats.new({ number: chat_number })
          if @chat.save
            render json: @chat.as_json(except: [:id, :application_id]), status: :created
          else
            render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Failed to acquire lock for chat creation' }, status: :unprocessable_entity
        end
    end
  
    def destroy
        @chat.destroy
        head :no_content
    end
  
    private
  
    def set_application
      @application = Application.find_by(token: params[:application_token])
      render json: { error: 'Application not found' }, status: :not_found unless @application
    end
  
    def set_chat
      @chat = @application.chats.find_by(number: params[:number])
      render json: { error: 'Chat not found' }, status: :not_found unless @chat
    end
end
