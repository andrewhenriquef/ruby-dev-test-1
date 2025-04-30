# spec/requests/api/v1/documents_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/documents', type: :request do
  path '/api/v1/directories/{directory_id}/documents' do
    let(:directory)    { create(:directory) }
    let(:directory_id) { directory.id }
    let!(:document)    { create(:document, directory:) }

    parameter name: :directory_id,
              in: :path,
              type: :integer,
              description: 'directory id'

    get('list documents') do
      tags 'Documents'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id:           { type: :integer },
                   name:         { type: :string },
                   directory_id: { type: :integer },
                   created_at:   { type: :string, format: :'date-time' },
                   updated_at:   { type: :string, format: :'date-time' }
                 },
                 required: %w[id name directory_id created_at updated_at]
               }

        run_test!
      end
    end

    post 'Creates a document' do
      tags 'Documents'
      consumes 'multipart/form-data'      # ← multipart, not JSON
      produces 'application/json'

      parameter name: :directory_id,
                in: :path,
                type: :integer,
                description: 'directory id'

      parameter name: 'document[name]',
                in: :formData,
                type: :string,
                required: true,
                description: 'the filename'

      parameter name: 'document[file]',
                in: :formData,
                type: :file,
                required: true,
                description: 'the file to upload'

      response '201', 'document created' do
        let(:dummy_file_path) { Rails.root.join('spec/fixtures/files/test.txt') }
        let(:'document[name]') { 'test.txt' }
        let(:'document[file]') { Rack::Test::UploadedFile.new(dummy_file_path, 'text/plain') }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq('test.txt')
          expect(data['directory_id']).to eq(directory.id)
        end
      end

      response '422', 'unprocessable_entity' do
        let(:'document[name]') { nil }
        let(:'document[file]') { nil }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['file']).to eq([ "can't be blank" ])
        end
      end
    end
  end

  path '/api/v1/directories/{directory_id}/documents/{id}' do
    let(:directory)    { create(:directory) }
    let!(:document)    { create(:document, directory:) }
    let(:directory_id) { directory.id }
    let(:id)           { document.id }

    parameter name: :directory_id, in: :path, type: :integer, description: 'directory id'
    parameter name: :id,           in: :path, type: :integer, description: 'document id'

    get('show document') do
      tags 'Documents'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id:           { type: :integer },
                 name:         { type: :string },
                 directory_id: { type: :integer },
                 created_at:   { type: :string, format: :'date-time' },
                 updated_at:   { type: :string, format: :'date-time' }
               },
               required: %w[id name directory_id created_at updated_at]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq(document.name)
          expect(data['directory_id']).to eq(directory.id)
        end
      end

      response '404', 'not found' do
        let(:id) { '99999' }
        run_test!
      end
    end

    put('update document') do
      tags 'Documents'
      consumes 'multipart/form-data'
      parameter name: :directory_id, in: :path, type: :integer
      parameter name: :id,           in: :path, type: :integer
      parameter name: 'document[file]', in: :formData, type: :file, required: true

      response '200', 'document updated' do
        let(:dummy_file_path)      { Rails.root.join('spec/fixtures/files/test.txt') }
        let(:'document[file]')     { Rack::Test::UploadedFile.new(dummy_file_path, 'text/plain') }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['name']).to eq(document.name)
        end
      end

      response '422', 'unprocessable_entity' do
        let(:'document[file]') { nil }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['file']).to eq([ "can't be blank" ])
        end
      end
    end

    delete('delete document') do
      tags 'Documents'
      consumes 'application/json'
      produces 'application/json'

      response '204', 'document deleted' do
        run_test!
      end

      response '404', 'not found' do
        let(:id) { '99999' }
        run_test!
      end
    end
  end
end
