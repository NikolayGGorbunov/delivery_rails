# frozen_string_literal: true

class PackagesController < ApplicationController
  before_action :authenticate_user!

  helper_method :sort_column, :sort_direction

  def index
    authorize Package
    @packages = policy_scope(Package).order("#{sort_column} #{sort_direction}").page(params[:page])
  end

  def show
    @package = Package.find(params[:id])
    authorize @package
  end

  def create
    authorize Package
    output = Packages::Create.run(params.fetch(:package).merge(user: current_user))

    if output.valid?
      redirect_to(output.result)
    else
      @package = output
      render :new
    end
  end

  def edit
    package = Package.find(params[:id])
    authorize package
    @package = Packages::Update.new(**package.attributes, package: package, user: package.user)
  end

  def update
    package = Package.find(params[:id])
    authorize package
    output = Packages::Update.run(**params.permit![:packages_update], package: package)

    if output.valid?
      redirect_to(output.result)
    else
      @package = output
      render :edit
    end
  end

  def new
    @package = Packages::Create.new
  end

  def destroy
    authorize Package
    Packages::Destroy.run!(package: current_user.packages.find(params[:id]))
    redirect_to root_path
  end

  private

  def sort_column
    Package.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end
end
