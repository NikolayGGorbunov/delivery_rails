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

  shared_examples 'when wrong organization/role' do
    it "don't update package" do
      subject
      expect(Package.find(pack0.id).length).not_to eq(100)
    end

    it 'redirect and flash error message' do
      expect(subject).to redirect_to(root_path)
      expect(flash[:alert]).to be_present
    end
  end

  describe '#index' do
    subject(:pack_index) { get :index }
    subject(:sort) { get :index, params: sort_params }
    let(:sort_params) { { direction: 'asc', sort: 'id' } }

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

      before { sign_in admin0 }

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

    before { sign_in user0 }

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
      before { sign_out user0 }

      it "don't create package in DB" do
        expect { pack_create }.to change(Package, :count).by(0)
      end

      include_examples 'when log out'
    end

    include_examples 'when user dont have org'
  end

  describe '#update' do
    subject(:pack_update) { patch :update, params: update_params }

    let(:org0) { create :organization }
    let(:org1) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org1}
    let(:admin0) { create :orgadmin, organization: org0 }
    let(:admin1) { create :orgadmin, organization: org1 }
    let(:pack0) { create :package, user: user0 }
    let(:pack1) { create :package, user: user1 }
    let(:update_params) { { id: pack0.id, packages_update: { **pack0.attributes, length: 100, aasm_state: 'returned' } } }

    include_examples 'when log out'

    context 'when user is operator' do
      before { sign_in user0 }

      include_examples 'when wrong organization/role'
    end

    context 'when package from other organization' do
      before { sign_in admin1 }

      include_examples 'when wrong organization/role'
    end

    context 'when user is admin and package from his organization' do
      before { sign_in admin0 }

      it 'update package' do
        VCR.use_cassette 'controller update package' do
          pack_update
          expect(Package.find(pack0.id).length).to eq(100)
          expect(Package.find(pack0.id).aasm_state).to eq('returned')
        end
      end
    end

    context 'when params is invalid' do
      let(:update_params) { { id: pack0.id, packages_update: { **pack0.attributes, length: 'jhdasdh', aasm_state: 'returned' } } }

      before { sign_in admin0 }

      it 'not update package' do
        expect(pack_update).to render_template("packages/edit")
        expect(Package.find(pack0.id).length).not_to eq(100)
        expect(Package.find(pack0.id).aasm_state).not_to eq('returned')
      end
    end
  end
end
