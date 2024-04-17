# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event::RegisterForm do
  subject(:form) { described_class.new(event, params) }

  let(:event) { create(:event, :published, :open_for_registration) }
  let(:player) { create(:user) }
  let(:params) { { player: } }

  it 'is valid with valid attributes' do
    expect(form).to be_valid
  end

  it 'is invalid without a player' do
    form.player = nil
    expect(form).to be_invalid
  end

  it 'is invalid when registration is not yet open', :aggregate_failures do
    event.registration_starts_at = 1.day.from_now
    expect(form).to be_invalid
    expect(form.errors).to be_of_kind(:base, :not_open_for_registration)
  end

  it 'is invalid when registration is closed', :aggregate_failures do
    event.registration_ends_at = 1.day.ago
    expect(form).to be_invalid
    expect(form.errors).to be_of_kind(:base, :not_open_for_registration)
  end

  it 'is valid when the player is already registered' do
    event.register(player)
    expect(form).to be_valid
  end

  describe '#save' do
    subject(:save) { form.save }

    it 'registers the player for the event' do
      expect { save }.to change { event.registered?(player) }.from(false).to(true)
    end

    it 'returns the registration' do
      expect(save).to be_a(Registration).and have_attributes(player:, event:)
    end

    context 'when the player is already registered' do
      let!(:registration) { event.register(player) }

      it 'does not create a new registration' do
        expect { save }.not_to change { event.registrations.count }
      end

      it 'returns the existing registration' do
        expect(save).to eq(registration)
      end
    end

    context 'when the event requires a decklist' do
      let(:event) { create(:constructed_event, :published, :open_for_registration, :with_decklist_config) }

      it 'does not save the registration without a decklist' do
        expect { save }.not_to change { event.registered?(player) }
      end

      it 'adds an error when the decklist is missing', :aggregate_failures do
        expect(save).to be_falsey
        expect(form.errors).to be_of_kind(:base, :decklist_required)
      end

      context 'with a decklist' do
        let(:params) { { player:, decklist_attributes: } }
        let(:decklist_attributes) { attributes_for(:decklist) }

        it 'saves the registration with the decklist', :aggregate_failures do
          expect { save }.to change { event.registered?(player) }.from(false).to(true)
          expect(save.decklist).to have_attributes(decklist_attributes)
        end

        it 'does not save the registration with an invalid decklist', :aggregate_failures do
          decklist_attributes[:ponyhead_url] = 'invalid'
          expect { save }.not_to change { event.registered?(player) }
        end
      end
    end
  end
end
