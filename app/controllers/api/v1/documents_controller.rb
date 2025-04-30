module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :set_directory
      before_action :set_document, only: [ :show, :update, :destroy ]

      def index
        @documents = @directory.documents
        render json: @documents
      end

      def show
        render json: @document
      end

      def create
        @document = @directory.documents.build(document_params)

        if @document.save
          render json: @document, status: :created
        else
          render json: @document.errors, status: :unprocessable_entity
        end
      end

      def update
        if @document.update(document_params)
          render json: @document
        else
          render json: @document.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @document.destroy
        head :no_content
      end

      private

      def set_directory
        @directory = Directory.find(params[:directory_id])
      end

      def set_document
        @document = @directory.documents.find(params[:id])
      end

      def document_params
        params.require(:document).permit(:name, :file)
      end
    end
  end
end
