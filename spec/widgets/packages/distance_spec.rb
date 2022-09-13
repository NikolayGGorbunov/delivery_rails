# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Distance, type: :widget do
  describe '#call' do
    subject(:call) { described_class.call(Organization.first.id, param) }

    let(:org0) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org0 }

    before do
      create :package, user: user0, distance: 200
      create :package, user: user1, distance: 100
    end

    context 'when param is max' do
      let(:param) { :max }

      it 'give right data' do
        expect(call[:data]).to include("#{user0.packages.first.id} | #{Package.first.distance}")
      end
    end

    context 'when param is min' do
      let(:param) { :min }

      it 'give right data' do
        expect(call[:data]).to include("#{user1.packages.first.id} | #{Package.last.distance}")
      end
    end

    context 'when param is nil' do
      subject(:call) { described_class.call(Organization.first.id) }

      it 'give right data' do
        expect(call[:data]).to include("#{user1.packages.first.id} | #{Package.last.distance}")
      end
    end
  end
end
