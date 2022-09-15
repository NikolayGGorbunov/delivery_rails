# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def initialize(current_user, target_user)
    @target_user = target_user
    @current_user = current_user
  end

  def show?
    @current_user.organization.present? && (@current_user.organization == @target_user.organization) &&
      (@current_user == @target_user || @current_user.admin?)
  end
end
