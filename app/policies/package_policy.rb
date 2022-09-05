# frozen_string_literal: true

class PackagePolicy < ApplicationPolicy
  class Scope < Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.where('user_id': user.organization.users.ids).order('created_at desc')
      else
        scope.where('user_id': user.id)
      end
    end
  end

  def initialize(user, package)
    @user = user
    @package = package
  end

  def index?
    @user.organization.present?
  end

  def show?
    @user.organization.present? && (@user.id == @package.user_id || @user.admin?)
  end

  def new?
    @user.organization.present?
  end

  def create?
    @user.organization.present?
  end

  def edit?
    @user.organization.present?
  end

  def update?
    @user.organization.present?
  end

  def destroy?
    @user.organization.present?
  end
end
