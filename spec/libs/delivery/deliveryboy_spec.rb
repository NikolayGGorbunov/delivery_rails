# frozen_string_literal: true

require 'rails_helper'
require 'vcr'
require 'yaml'

RSpec.describe Delivery::Deliveryboy do
  describe '.give_package' do
    subject(:instance) { described_class.give_package(data) }

    context 'when no way between cities' do
      let(:data) do
        { weight: '5.1', length: '1', width: '1', height: '1', start_point: 'krasnodar', end_point: 'norilsk' }
      end

      it "raise 'No route' error" do
        VCR.use_cassette 'give package no route' do
          expect { instance }.to raise_error(RuntimeError, 'No route')
        end
      end
    end

    context 'when fake cities' do
      let(:data) do
        { weight: '5.1', length: '1', width: '1', height: '1', start_point: 'hsfafjsfa', end_point: 'shdbjvfsaj' }
      end

      it "raise 'city not found' error" do
        VCR.use_cassette 'give package no city' do
          expect { instance }.to raise_error(RuntimeError, 'City not found')
        end
      end
    end

    context 'when wrong parameters' do
      let(:data) do
        { weight: '-5.1', length: '0', width: '0', height: '0', start_point: 'krasnodar', end_point: 'moscow' }
      end

      it "raise 'Wrong arguments' error" do
        VCR.use_cassette 'give package wrong arg' do
          expect { instance }.to raise_error(RuntimeError, 'Wrong arguments')
        end
      end
    end

    context 'when same cities' do
      let(:data) do
        { weight: '5.1', length: '1', width: '1', height: '1', start_point: 'krasnodar', end_point: 'krasnodar' }
      end

      it "raise 'same city' error" do
        VCR.use_cassette 'give package same cities' do
          expect { instance }.to raise_error(RuntimeError, 'Choose different cities')
        end
      end
    end

    context 'when city name is empty' do
      let(:data) do
        { weight: '5.1', length: '1', width: '1', height: '1', start_point: '', end_point: ' ' }
      end

      it "raise 'same city' error" do
        VCR.use_cassette 'give package empty city' do
          expect { instance }.to raise_error(RuntimeError, "City name can't be empty")
        end
      end
    end

    context 'when size < 1 cubic meter and correct city names' do
      let(:data) do
        { weight: '5.1', length: '1', width: '1', height: '1', start_point: 'krasnodar', end_point: 'moscow' }
      end

      it 'return hash' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to be_kind_of(Hash)
        end
      end

      it 'price == distance' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to include({ distance: 1351, price: 1351 })
        end
      end
    end

    context 'when size > 1 cubic meter, weight < 10 kg and correct city names' do
      let(:data) do
        { weight: '5.1', length: '200', width: '200', height: '200', start_point: 'krasnodar', end_point: 'moscow' }
      end

      it 'return hash' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to be_kind_of(Hash)
        end
      end

      it 'price == distance*2' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to include({ distance: 1351, price: 1351 * 2 })
        end
      end
    end

    context 'when size > 1 cubic meter, weight > 10 kg and correct city names' do
      let(:data) do
        { weight: '11.0', length: '200', width: '200', height: '200', start_point: 'krasnodar', end_point: 'moscow' }
      end

      it 'return hash' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to be_kind_of(Hash)
        end
      end

      it 'price == distance*3' do
        VCR.use_cassette 'give package valid' do
          expect(instance).to include({ distance: 1351, price: 1351 * 3 })
        end
      end
    end
  end
end
