# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Create, type: :interactor do
  let(:user0) { create :user }

  describe '#create' do
    subject(:interaction) { described_class.run(params) }

    context 'when params are valid' do
      let(:params) { attributes_for(:package).merge(user: user0) }

      it 'create package' do
        VCR.use_cassette 'interactor create package' do
          expect { interaction }.to change(Package, :count).by(1)
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { { weight: -10, user: user0 } }

      it 'dont create package' do
        VCR.use_cassette 'interactor try create package with invalid params' do
          expect { interaction }.to change(Package, :count).by(0)
        end
      end

      it 'add errors into interactor.errrors' do
        VCR.use_cassette 'interactor try create package with invalid params' do
          expect(interaction.errors).not_to be_empty
        end
      end
    end
  end
end
