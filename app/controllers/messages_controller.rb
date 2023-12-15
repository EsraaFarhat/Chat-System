class MessagesController < ApplicationController
    before_action :set_application
    before_action :set_chat
    before_action :set_message, only: [:show, :update, :destroy]

    def index
       order_by = params[:orderBy]&.downcase || 'created_at'
       order_direction = params[:order]&.downcase || 'desc'

       # Validate that order_by is a valid column name to prevent SQL injection
       valid_columns = ['body', 'number', 'created_at', 'updated_at']
       order_by = valid_columns.include?(order_by) ? order_by : 'created_at'
       valid_directions = ['asc', 'desc']
       order_direction = valid_directions.include?(order_direction) ? order_direction : 'desc'

       @messages = @chat.messages.order("#{order_by} #{order_direction}").all
       render json: @messages.as_json(except: [:id, :chat_id])
    end
  
    def show
        render json: @message.as_json(except: [:id, :chat_id])
    end
  
    def create
      message_number = @chat.next_message_number

      if message_number.present?
        @message = @chat.messages.new(message_params.merge(number: message_number))
        if @message.save
          render json: @message.as_json(except: [:id, :chat_id]), status: :created
        else
          render json: { errors: @application.errors.full_messages.first }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Failed to acquire lock for message creation' }, status: :unprocessable_entity
      end
    end
  
    def update
      if @message.update(message_params)
        render json: @message.as_json(except: [:id, :chat_id])
      else
        render json: { errors: @application.errors.full_messages.first }, status: :unprocessable_entity
      end
    end

    def destroy
        @message.destroy
        head :no_content
    end
  
    private
  
    def set_application
        @application = Application.find_by(token: params[:application_token])
        render json: { error: 'Application not found' }, status: :not_found unless @application
      end
    
      def set_chat
        puts (params[:number])
        @chat = @application.chats.find_by(number: params[:chat_number])
        render json: { error: 'Chat not found' }, status: :not_found unless @chat
      end
    
      def set_message
        @message = @chat.messages.find_by(number: params[:message_number])
        render json: { error: 'Message not found' }, status: :not_found unless @message
      end
    
      def message_params
        params.permit(:body)
    end
end
