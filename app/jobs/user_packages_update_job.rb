# frozen_string_literal: true

class UserPackagesUpdateJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    user.packages.each do |package|
      Packages::Update.run(**package.attributes, package: package, user: user)
    end
  end
end
