# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Destroy, type: :interactor do
  let(:user0) { create :user }

  describe '#destory' do
    subject(:interaction) { described_class.run(params) }

    before do
      create :package, user: user0
    end

    context 'when package exist' do
      let(:params) { { package: user0.packages.last } }

      it 'destroy package' do
        expect { interaction }.to change(Package, :count).by(-1)
      end

      it 'destroy package' do
        expect { interaction }.to change(user0.packages, :count).by(-1)
      end
    end

    context 'when package doesnt exist' do
      let(:params) { { package: user0.packages.find(-1) } }

      it 'raise record_not_found error' do
        expect { interaction }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
