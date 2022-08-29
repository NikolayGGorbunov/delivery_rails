# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Package, type: :model do
  describe 'aasm' do
    let(:package_accepted) { build :accepted_package }
    let(:package_returned) { build :returned_package }
    let(:package_delivery) { build :delivery_package }
    let(:package_delivered) { build :delivered_package }

    context 'when package new (accepted)' do
      it 'created with accepted state' do
        expect(package_accepted).to have_state(:accepted)
      end

      it 'can change state to returned' do
        expect(package_accepted).to transition_from(:accepted).to(:returned).on_event(:returning)
      end

      it 'can change state to delivery' do
        expect(package_accepted).to transition_from(:accepted).to(:delivery).on_event(:delivering)
      end

      it 'allowed only returning end delivering' do
        expect(package_accepted).to allow_event :returning
        expect(package_accepted).to allow_event :delivering
        expect(package_accepted).not_to allow_event :ending
      end
    end

    context 'when package returned' do
      it 'had retirned state' do
        expect(package_returned).to have_state(:returned)
      end

      it 'not allowed any actions' do
        expect(package_returned).not_to allow_event :returning
        expect(package_returned).not_to allow_event :delivering
        expect(package_returned).not_to allow_event :ending
      end
    end

    context 'when package delivery' do
      it 'had delivery state' do
        expect(package_delivery).to have_state(:delivery)
      end

      it 'allow only ending action' do
        expect(package_delivery).not_to allow_event :returning
        expect(package_delivery).not_to allow_event :delivering
        expect(package_delivery).to allow_event :ending
      end

      it 'can change state to delivered' do
        expect(package_delivery).to transition_from(:delivery).to(:delivered).on_event(:ending)
      end
    end

    context 'when package delivered' do
      it 'had delivered state' do
        expect(package_delivered).to have_state(:delivered)
      end

      it 'not allowed any actions' do
        expect(package_delivered).not_to allow_event :returning
        expect(package_delivered).not_to allow_event :delivering
        expect(package_delivered).not_to allow_event :ending
      end
    end
  end
end
