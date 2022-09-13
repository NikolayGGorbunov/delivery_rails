# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    authorize @user
    if current_user.admin? && Package.of_org_by(current_user.organization_id).present?
      org_id = @user.organization_id
      @widgets = [
        Packages::Price.call(org_id),
        Packages::Price.call(org_id, :average),
        Packages::Distance.call(org_id, :max),
        Packages::Distance.call(org_id),
        Packages::Count.call(org_id),
        Packages::Count.call(org_id, :sorted)
      ]
    end
  end
end
