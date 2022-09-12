# frozen_string_literal: true

require 'rails_helper'



RSpec.describe UserPackagesUpdateJob do


  subject(:job) { described_class.perform_async(params) }

  let(:user0) { create :user }
  let(:packages) { create_list(:package, 5, user: user0) }

  context 'when user has some packages' do
    before do
      packages
      user0.update(first_name: 'NewName')
    end

    let(:params) { user0.id }


    it "run update for all user's packages" do
      Sidekiq::Testing.inline! do
        allow(Packages::Update).to receive(:run).and_return(1)
        expect(Packages::Update).to receive(:run).exactly(5).times
        job
      end
    end

    it 'queing job into Redis' do
      job
      expect(UserPackagesUpdateJob.jobs.size).to eq(1)
    end
  end
end
