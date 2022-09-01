# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Index, type: :interactor do
  let(:user0) { create :user }
  let(:user1) { create :user, email: 'user1@user1.com' }

  describe '#index' do
    subject(:interaction) { described_class.run(params) }

    before do
      create :package, user: user0, distance: 200, price: 200
      create :package, user: user0, distance: 100, price: 100
      create :package, user: user1
    end

    context 'with packages in DB' do
      let(:params) { { id: user0.id, user: user0 } }

      it 'returns valid package' do
        expect(interaction.valid?).to eq(true)
      end

      it 'return has no errors' do
        expect(interaction.errors).to be_empty
      end

      it 'return all user packages' do
        expect(interaction.result).to eq(user0.packages.all)
      end

      it 'return exactly 2 packages' do
        expect(interaction.result.size).to eq(2)
      end

      context 'when first package > second by distance' do
        let(:params) { { user: user0, direction: 'asc', sort: 'distance' } }

        it 'sort correctly' do
          expect(interaction.result).to eq([user0.packages.last, user0.packages.first])
        end
      end

      context 'when first package > second by distance (reverse)' do
        let(:params) { { user: user0, direction: 'desc', sort: 'distance' } }

        it 'sort correctly' do
          expect(interaction.result).to eq([user0.packages.first, user0.packages.last])
        end
      end
    end
  end
end
