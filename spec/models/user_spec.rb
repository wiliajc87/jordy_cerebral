# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject do
    described_class.new(name: 'Buddy Baker',
                        email: 'animal_man@dc.com')
  end

  describe 'validations and defaults' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'email' do
      it 'is not valid without a email' do
        subject.email = nil
        expect(subject).not_to be_valid
      end

      it 'is not valid with invalid formats' do
        expect(subject).to be_valid
        subject.email = 'bleh'
        expect(subject).not_to be_valid
        subject.email = 'd@.com'
        expect(subject).not_to be_valid
        subject.email = '@.com'
        expect(subject).not_to be_valid
        subject.email = 'animal_man@dc.com'
        expect(subject).to be_valid
      end
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'defaults to status: new' do
      expect(subject.status).to eq 'new'
    end

    it 'is not valid without a status' do
      subject.status = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'status changes' do
    it 'cannot change from new to cancelled' do
      subject.status = 'new'

      expect { subject.cancel }.to raise_error(AASM::InvalidTransition)
    end

    it 'cannot change from cancelled to paid' do
      subject.status = 'cancelled'

      expect { subject.pay }.to raise_error(AASM::InvalidTransition)
    end
  end
end
