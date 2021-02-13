# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Payments', type: :request do
  describe 'POST /payments' do
    context 'user status is new' do
      before do
        User.create(name: 'Buddy Baker', email: 'animal_man@dc.com')
      end

      it 'returns new user page' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        post '/payments', params: { user_id: 1 }
        expect(response).to have_http_status(:redirect)
        expect(User.find(1).status).to eq 'paid'
        expect(response).to redirect_to(user_path(1))

        follow_redirect!

        expect(response.body).to include('paid')
      end
    end

    context 'user status is not new' do
      before do
        User.create(name: 'Buddy Baker', email: 'animal_man@dc.com', status: 'cancelled')
      end

      it 'returns redirects to show without changing status' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        post '/payments', params: { user_id: 1 }
        expect(response).to have_http_status(:redirect)
        expect(User.find(1).status).to eq 'cancelled'
        expect(response).to redirect_to(user_path(1))

        follow_redirect!

        expect(response.body).to include('cancelled')
      end
    end
  end

  describe 'DELETE /payments' do
    context 'user status is paid' do
      before do
        User.create(name: 'Buddy Baker', email: 'animal_man@dc.com', status: 'paid')
      end

      it 'returns new user page' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        delete '/payments/1', params: { user_id: 1 }
        expect(response).to have_http_status(:redirect)
        expect(User.find(1).status).to eq 'cancelled'
        expect(response).to redirect_to(user_path(1))

        follow_redirect!

        expect(response.body).to include('cancelled')
      end
    end

    context 'user status is not paid' do
      before do
        User.create(name: 'Buddy Baker', email: 'animal_man@dc.com', status: 'new')
      end

      it 'returns redirects to show without changing status' do
        allow_any_instance_of(ActionDispatch::Request).to receive(:session).and_return({ current_user_id: '1' })

        delete '/payments/1', params: { user_id: 1 }
        expect(response).to have_http_status(:redirect)
        expect(User.find(1).status).to eq 'new'
        expect(response).to redirect_to(user_path(1))

        follow_redirect!

        expect(response.body).to include('new')
      end
    end
  end
end
