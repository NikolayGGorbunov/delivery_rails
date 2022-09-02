# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PackagesController, type: :controller do
  shared_examples 'when log out' do
    it 'redirect to sign in' do
      sign_out user0
      expect(subject).to redirect_to(new_user_session_path)
    end
  end

  shared_examples 'when user dont have org' do
    it 'redirect to new package and flash message' do
      sign_in user2
      expect(subject).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe '#index' do
    subject(:pack_index) { get :index }

    let(:sort) { get :index, params: sort_params }
    let(:org0) { create :organization }
    let(:org1) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org1 }
    let(:user2) { create :user }
    let(:admin0) { create :orgadmin, organization: org0 }
    let(:admin1) { create :orgadmin, organization: org1 }

    before do
      sign_in user0
      create :package, user: user0, distance: 200, price: 200
      create :package, user: user0, distance: 100, price: 100
      create :package, user: user1
    end

    context 'with packages in DB' do
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

    context 'when user is organization admin' do
      let(:sort_params) { { direction: 'asc', sort: 'distance' } }

      before do
        sign_in admin0
      end

      it 'assign all organization packages' do
        pack_index
        expect(assigns(:packages)).to match_array(user0.packages.all)
      end

      it 'sort correctly' do
        sort
        expect(assigns(:packages)).to eq([user0.packages.last, user0.packages.first])
      end
    end

    context 'when first package > second by distance' do
      let(:sort_params) { { direction: 'asc', sort: 'distance' } }

      it 'sort correctly' do
        sort
        expect(assigns(:packages)).to eq([user0.packages.last, user0.packages.first])
      end
    end

    context 'when first package > second by distance (reverse)' do
      let(:sort_params) { { direction: 'desc', sort: 'distance' } }

      it 'sort correctly' do
        sort
        expect(assigns(:packages)).to eq([user0.packages.first, user0.packages.last])
      end
    end

    include_examples 'when log out'
    include_examples 'when user dont have org'
  end

  describe '#show' do
    subject(:pack_show) { get :show, params: { id: Package.last.id } }

    let(:org1) { create :organization }
    let(:user0) { create :user, organization: org1 }
    let(:user2) { create :user }

    before do
      sign_in user0
      create :package, user: user0
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

    include_examples 'when log out'
    include_examples 'when user dont have org'
  end

  describe '#create' do
    subject(:pack_create) { process :create, method: :post, params: { package: params } }

    let(:org1) { create :organization }
    let(:user0) { create :user, organization: org1 }
    let(:user2) { create :user }
    let(:params) { attributes_for :package }

    before do
      sign_in user0
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

    context 'when user sign out' do
      before do
        sign_out user0
      end

      it "don't create package in DB" do
        expect { pack_create }.to change(Package, :count).by(0)
      end

      include_examples 'when log out'
    end

    include_examples 'when user dont have org'
  end
end
