# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  shared_examples 'when log out' do
    it 'redirect to sign in' do
      expect(subject).to redirect_to(new_user_session_path)
    end
  end


  describe '#index' do
    subject(:pack_index) { get :index }
    let(:user0) { create :user }
    let(:user1) { create :user, email: 'user1@user1.com' }

    before do
      sign_in user0
      create :package, user: user0, distance: 200, price: 200
      create :package, user: user0, distance: 100, price: 100
      create :package, user: user1
    end

    context 'with packages in BD' do
      it 'returns http succes' do
        pack_index
        expect(response).to have_http_status(:success)
      end

      it 'assign all user packages' do
        pack_index
        expect(assigns(:packages)).to eq(user0.packages.all)
      end

      it 'assign exactly 2 packages' do
        pack_index
        expect(assigns(:packages).size).to eq(2)
      end

    end

    context 'when user sign out' do
      before do
        sign_out user0
      end
      subject { get :index }
      include_examples 'when log out'
    end


    subject(:sort) { get :index, params: sort_params  }

    context 'when packages first pack > second by distance' do
      let(:sort_params) { { direction: 'asc', sort: 'distance' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.last, user0.packages.first])
      end
    end

    context 'when packages first pack > second by distance (reverse)' do
      let(:sort_params) { { direction: 'desc', sort: 'distance' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.first, user0.packages.last])
      end
    end

    context 'when packages first pack > second by price' do
      let(:sort_params) { { direction: 'asc', sort: 'price' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.last, user0.packages.first])
      end
    end

    context 'when packages first pack > second by price (reverse)' do
      let(:sort_params) { { direction: 'desc', sort: 'price' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.first, user0.packages.last])
      end
    end

    context 'when packages first pack > second by date' do
      let(:sort_params) { { direction: 'asc', sort: 'updated_at' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.first, user0.packages.last])
      end
    end

    context 'when packages first pack > second by price (reverse)' do
      let(:sort_params) { { direction: 'desc', sort: 'updated_at' } }

      it "sort correctly" do
        sort
        expect(assigns(:packages)).to eq([user0.packages.last, user0.packages.first])
      end
    end
  end

  describe '#show' do
    subject(:pack_show) { get :show, params: { id: Package.last.id } }
    let(:user0) { create :user }

    before do
      sign_in user0
      create :package, user: user0
    end

    context 'when user sign out' do
      before do
        sign_out user0
      end
      subject(:pack_show) { get :show, params: { id: Package.last.id } }
      include_examples 'when log out'
    end

    context 'with valid package-id' do
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
    let(:user0) { create :user }
    let(:params) { attributes_for :package }

    before do
      sign_in user0
    end

    context 'when user sign out' do
      before do
        sign_out user0
      end
      subject(:pack_create) { process :create, method: :post, params: { package: params } }
      include_examples 'when log out'
    end

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
