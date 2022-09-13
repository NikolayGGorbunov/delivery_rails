# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::DefaultWidget, type: :widget do
  describe '.initialize' do
    subject(:init) { described_class.new(params) }

    let(:org0) { create :organization }
    let(:user0) { create :user, organization: org0 }

    before do
      create :package, user: user0
      create :package, user: user0
    end

    context 'when group_by parameter is nil' do
      let(:params) { Organization.first.id }

      it 'assign relation' do
        expect(init.relation).to eq(Package.of_org_by(Organization.first.id))
      end
    end

    context 'when group_by parameter is something' do
      subject(:init) { described_class.new(Organization.first.id, :user_id) }

      it 'assign right relation' do
        expect(init.relation).to eq(Package.of_org_by(Organization.first.id, :user_id))
      end
    end
  end

  describe '#call' do
    subject(:call) { described_class.call }

    it 'raise error always' do
      expect{call}.to raise_error(RuntimeError, "Can't call default widgets. Use descendant call")
    end
  end
end
