# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#show' do
    subject(:show) { get :show, params: show_params }

    let(:org0) { create :organization }
    let(:org1) { create :organization }
    let(:user0) { create :user, organization: org0 }
    let(:user1) { create :user, organization: org1 }
    let(:user2) { create :user }
    let(:admin0) { create :orgadmin, organization: org0 }

    context 'when user sign_out' do
      let(:show_params) { { id: user0.id } }
      it 'redirect to login page' do
        expect(show).to redirect_to(new_user_session_path)
      end
    end

    context 'when user without organization' do
      let(:show_params) { { id: user2.id } }
      it 'redirect to root and show alert' do
        sign_in user2
        expect(show).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end

    context 'when user is not admin' do
      let(:show_params) { { id: user0.id } }
      before { sign_in user0 }

      it 'render show without widgets' do
        expect(show).to render_template('users/show')
        expect(assigns[:widgets]).not_to be_present
      end

      context "try to show self org user" do
        let(:show_params) { { id: admin0.id } }
        it 'redirect to root and show alert' do
          expect(show).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end

      context "try to show other org user" do
        let(:show_params) { { id: user2.id } }
        it 'redirect to root and show alert' do
          expect(show).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end

    end

    context 'when user is admin' do
      let(:show_params) { { id: admin0.id } }

      before do
        sign_in user0
        create :package, user: user0
        create :package, user: user1
      end

      it 'render show with widgets' do
        sign_in admin0
        expect(show).to render_template('users/show')
        expect(assigns[:widgets]).to be_present
      end

      context "try to show self org user" do
        let(:show_params) { { id: user0.id } }
        it 'render show with widgets' do
          sign_in admin0
          expect(show).to render_template('users/show')
          expect(assigns[:widgets]).to be_present
        end
      end

      context "try to show other org user" do
        let(:show_params) { { id: user1.id } }
        it 'redirect to root and show alert' do
          sign_in admin0
          expect(show).to redirect_to(root_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
