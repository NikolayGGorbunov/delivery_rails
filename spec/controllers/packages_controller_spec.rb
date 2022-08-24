# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  describe '#index' do
    subject(:pack_index) { get :index }

    before :context do
      create :package
      create :package
    end

    context 'has packages in BD' do
      it 'returns http succes' do
        pack_index
        expect(response).to have_http_status(:success)
      end

      it 'assign all packages' do
        pack_index
        expect(assigns(:packages)).to eq(Package.all)
      end

      it 'assign exactly 2 packages' do
        pack_index
        expect(assigns(:packages).size).to eq(2)
      end
    end
  end

  describe '#show' do
    subject(:pack_show) { get :show, params: { id: Package.last.id } }

    before(:context) do
      create :package
    end

    context 'has valid package-id' do
      it 'returns http succes' do
        pack_show
        expect(response).to have_http_status(:success)
      end

      it 'assigns right post' do
        pack_show
        expect(assigns(:package)).to eq(Package.last)
      end
    end
  end

  describe '#create' do
    subject(:pack_create) { process :create, method: :post, params: { package: params } }

    let(:params) { attributes_for :package }

    it 'create package' do
      VCR.use_cassette 'controller create package' do
        expect { pack_create }.to change(Package, :count).by(1)
      end
    end

    it 'redirect to show' do
      VCR.use_cassette 'controller create package' do
        expect(pack_create).to redirect_to(package_path(id: Package.last.id))
      end
    end
  end
end
