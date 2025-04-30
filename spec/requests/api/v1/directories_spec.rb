require 'swagger_helper'

RSpec.describe 'api/v1/directories', type: :request do
  path '/api/v1/directories' do
    get('list directories') do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   parent_id: { type: [ :integer, :null ] },
                   created_at: { type: :datetime },
                   updated_at: { type: :datetime }
                 },
                 required: %w[id name parent_id created_at updated_at]
               }

        run_test!
      end
    end
  end

  path '/api/v1/directories/{id}' do
    let(:directory) { create(:directory) }
    let(:id) { directory.id }

    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show directory') do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 parent_id: { type: [ :integer, :null ] },
                 created_at: { type: :datetime },
                 updated_at: { type: :datetime }
               },
               required: %w[id name parent_id created_at updated_at]

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq(directory.name)
          expect(data['parent_id']).to eq(directory.parent_id)
        end
      end

      response(404, 'not found') do
        let(:id) { '123' }

        run_test!
      end
    end
  end

  path '/api/v1/directories/{id}/subdirectories' do
    let(:directory) { create(:directory) }
    let(:id) { directory.id }

    parameter name: 'id', in: :path, type: [ :integer, :string ], description: 'id'

    get('subdirectories directory') do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   parent_id: { type: [ :integer, :null ] },
                   created_at: { type: :datetime },
                   updated_at: { type: :datetime }
                 },
                 required: %w[id name parent_id created_at updated_at]
               }

        run_test!
      end
    end
  end

  path '/api/v1/directories' do
    post 'Creates a directory' do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :directory, in: :body, schema: {
        type: :object,
        properties: {
          directory: {
            type: :object,
            properties: {
              name:      { type: :string },
              parent_id: { type: [ :integer, 'null' ] }
            },
            required: [ 'name' ]
          }
        },
        required: [ 'directory' ]
      }

      response '201', 'directory created' do
        let(:name) { Faker::Lorem.word }
        let(:directory) do
          {
            directory: {
              name:,
              parent_id: nil
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq(name)
          expect(data['parent_id']).to be_nil
        end
      end

      response '422', 'unprocessable_entity' do
        let(:directory) do
          {
            directory: { name: nil }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data["name"]).to eq([ "can't be blank" ])
        end
      end
    end
  end

  path '/api/v1/directories/{id}' do
    let(:resource) { create(:directory) }
    let(:id) { resource.id }

    put 'Updates a directory' do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: 'id'
      parameter name: :directory, in: :body, schema: {
        type: :object,
        properties: {
          directory: {
            type: :object,
            properties: {
              name: { type: :string }
            },
            required: [ 'name' ]
          }
        }
      }

      response '200', 'directory updated' do
        let(:name) { Faker::Lorem.word }
        let(:directory) { { directory: { name: } } }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq(name)
        end
      end

      response '404', 'not found' do
        let(:id) { '123' }
        let(:directory) { { directory: { name: Faker::Lorem.word } } }

        run_test!
      end

      response '422', 'unprocessable_entity' do
        let(:directory) { { directory: { name: nil } } }

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data['name']).to eq([ "can't be blank" ])
        end
      end
    end
  end

  path '/api/v1/directories/{id}' do
    delete 'Deletes a directory' do
      tags 'Directories'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: 'id'

      response '204', 'directory deleted' do
        let(:resource) { create(:directory) }
        let(:id) { resource.id }

        run_test!
      end

      response '404', 'not found' do
        let(:id) { '123' }

        run_test!
      end
    end
  end
end
