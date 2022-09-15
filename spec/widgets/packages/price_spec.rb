# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Price, type: :widget do
  describe '#call' do
    subject(:call) { described_class.call(Organization.first.id, param) }

    let(:org0) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org0 }

    let!(:packages) do
      create_list(:package, 5, user: user0, price: 100)
      create_list(:package, 2, user: user1, price: 500)
    end

    context 'when param is all' do
      let(:param) { :all }

      it 'give right data' do
        expect(call[:data]).to eq(Package.of_org_by(Organization.first.id, :price).count.map{|key, value| key * value}.sum)
      end
    end

    context 'when param is nil' do
      subject(:call) { described_class.call(Organization.first.id) }

      it 'give right data' do
        expect(call[:data]).to eq(Package.of_org_by(Organization.first.id, :price).count.map{|key, value| key * value}.sum)
      end
    end

    context 'when param is average' do
      let(:param) { :average }

      it 'give right data' do
        expect(call[:data]).to eq(Package.group(:price).count.map{|key, value| key * value}.sum / Package.all.size )
      end
    end
  end
end
