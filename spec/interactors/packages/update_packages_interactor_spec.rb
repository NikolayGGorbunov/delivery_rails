# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Packages::Update, type: :interactor do
  let(:user0) { create :user }

  before do
    create :package, user: user0
  end

  describe '#update' do
    subject(:interaction) { described_class.run(params) }

    context 'when params are valid' do
      let(:params) { (attributes_for :package).merge(package: user0.packages.last, weight: 1000) }

      it 'update package' do
        VCR.use_cassette 'interactor update package' do
          expect(interaction.result.weight).to be(1000.0)
          expect(interaction.valid?).to be(true)
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { (attributes_for :package).merge(package: user0.packages.last, weight: -10) }

      it 'dont update package' do
        VCR.use_cassette 'interactor try update package with invalid params' do
          expect(interaction.valid?).to be(false)
        end
      end

      it 'add errors into interactor.errrors' do
        VCR.use_cassette 'interactor try update package with invalid params' do
          expect(interaction.errors).not_to be_empty
        end
      end
    end
  end
end
