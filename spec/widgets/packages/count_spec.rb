# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Count, type: :widget do
  describe '#call' do
    subject(:call) { described_class.call(Organization.first.id, param) }

    let(:org0) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org0 }

    let!(:packages) do
      create_list(:package, 5, user: user0)
      create_list(:package, 2, user: user1)
    end

    context 'when param is all' do
      let(:param) { :all }

      it 'give right data' do
        expect(call[:data]).to eq(Package.all.size)
      end
    end

    context 'when param is sorted' do
      let(:param) { :sorted }

      it 'give right data' do
        expect(call[:data]).to include("#{user0.id} = #{user0.packages.size}")
        expect(call[:data]).to include("#{user1.id} = #{user1.packages.size}")
      end
    end

    context 'when param is nil' do
      subject(:call) { described_class.call(Organization.first.id) }

      it 'give right data' do
        expect(call[:data]).to eq(Package.all.size)
      end
    end
  end
end
