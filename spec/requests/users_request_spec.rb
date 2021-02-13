# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /' do
    it 'returns new user page' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Sign up')
    end
  end

  describe 'GET /users/:id' do
    before do
      User.create(name: 'Buddy Baker', email: 'animal_man@dc.com')
      User.create(name: 'Ellen Frazier', email: 'ellen.frazier@dc.com')
    end

    context 'user accessing their show page' do
      it 'returns show page' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        get '/users/1'

        expect(response).to have_http_status(:success)
        expect(response.body).to include('Buddy Baker')
      end
    end

    context 'user accessing other users show page' do
      it 'redirects to new user page' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        get '/users/2'

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_user_path)

        follow_redirect!

        expect(response.body).to include('Sign up')
      end
    end
  end

  describe 'POST /users' do
    context 'with valid data' do
      it 'creates a new user and redirects to show' do
        expect do
          post '/users', params: { user: { name: 'Buddy Baker',
                                           email: 'animal_man@dc.com' } }
        end.to change(User, :count).from(0).to(1)

        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(user_path(1))
        expect(session[:current_user_id]).to eq(1)

        follow_redirect!

        expect(response.body).to include('Buddy Baker')
      end
    end

    context 'with missing data' do
      it 'does not create a new user' do
        expect do
          post '/users', params: { user: { name: 'Buddy Baker',
                                           email: '' } }
        end.not_to change(User, :count)

        expect(response).to redirect_to(new_user_path)
        expect(session[:current_user_id]).to eq(nil)

        follow_redirect!

        expect(response.body).to include('Sign up')
      end

      it 'renders new' do
        post '/users', params: { user: { name: 'Buddy Baker',
                                         email: '' } }

        follow_redirect!

        expect(response.body).to include('Sign up')
      end
    end
  end
end
