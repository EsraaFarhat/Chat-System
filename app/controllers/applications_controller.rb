class ApplicationsController < ApplicationController
    # get the application by token before performing these actions
    before_action :set_application, only: [:show, :update, :destroy]

    def index
        order_by = params[:orderBy]&.downcase || 'created_at'
        order_direction = params[:order]&.downcase || 'desc'

        # Validate that order_by is a valid column name to prevent SQL injection
        valid_columns = ['name', 'created_at', 'updated_at']
        order_by = valid_columns.include?(order_by) ? order_by : 'created_at'
        valid_directions = ['asc', 'desc']
        order_direction = valid_directions.include?(order_direction) ? order_direction : 'desc'

        @applications = Application.order("#{order_by} #{order_direction}").all
        render json: @applications.as_json(except: [:id])
    end

    def show
        render json: @application.as_json(except: [:id])
    end

    def create
        @application = Application.new(application_params)
        @application.token = generate_unique_token

        if @application.save
            render json: @application.as_json(except: [:id]), status: :created
        else
            render json: { error: @application.errors.full_messages.first }, status: :unprocessable_entity
        end
    end

    def update
        if @application.update(application_params)
            render json: @application.as_json(except: [:id])
        else
            render json: { errors: @application.errors.full_messages.first }, status: :unprocessable_entity
        end
    end

    def destroy
        @application.destroy
        head :no_content
    end

    private

    def set_application
        @application = Application.find_by(token: params[:token])
        render json: { error: 'Application not found' }, status: :not_found unless @application
    end

    def application_params
        params.permit(:name)
    end

    def generate_unique_token
        loop do
          token = SecureRandom.hex(16)
          break token unless Application.exists?(token: token)
        end
    end
end