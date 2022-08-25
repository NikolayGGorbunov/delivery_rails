# frozen_string_literal: true

class PackagesController < ApplicationController
  before_action :authenticate_user!

  helper_method :sort_column, :sort_direction

  def index
    output = Packages::Index.run(params.merge(user: current_user))
    @packages = output.result
  end

  def show
    @package = Package.find(params[:id])
  end

  def create
    output = Packages::Create.run(params.fetch(:package).merge(user: current_user))

    if output.valid?
      redirect_to(output.result)
    else
      @package = output
      render :new
    end
  end

  def edit
    package = current_user.packages.find(params[:id])
    @package = Packages::Update.new(package.attributes)
  end

  def update
    package = current_user.packages.find(params[:id])
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
    Packages::Destroy.run!(package: current_user.packages.find(params[:id]))
    redirect_to root_path
  end
end
