module Api
  module V1
    class DirectoriesController < ApplicationController
      before_action :set_directory, only: [ :show, :update, :destroy, :subdirectories ]

      def index
        @directories = Directory.all
        render json: @directories
      end

      def show
        render json: @directory
      end

      def create
        @directory = Directory.new(directory_params)

        if @directory.save
          render json: @directory, status: :created
        else
          render json: @directory.errors, status: :unprocessable_entity
        end
      end

      def update
        if @directory.update(directory_params)
          render json: @directory
        else
          render json: @directory.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @directory.destroy

        head :no_content
      end

      def subdirectories
        @subdirectories = @directory.subdirectories
        render json: @subdirectories
      end

      private

      def set_directory
        @directory = Directory.find(params[:id])
      end

      def directory_params
        params.require(:directory).permit(:name, :parent_id)
      end
    end
  end
end
