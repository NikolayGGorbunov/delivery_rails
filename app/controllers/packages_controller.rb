# frozen_string_literal: true

class PackagesController < ApplicationController
  before_action :authenticate_user!

  helper_method :sort_column, :sort_direction

  def index
    @packages = if params[:sort]
                  current_user.packages.order("#{sort_column} #{sort_direction}").page(params[:page])
                else
                  current_user.packages.page(params[:page])
                end
  end

  def show
    @package = Package.find(params[:id])
  end

  def create
    distance, price = Delivery::Deliveryboy.give_package(package_params).values_at(:distance, :price)
    @package = current_user.packages.new(package_params.merge!({ distance: distance, price: price,
                                                                 **current_user_attributes }))
    if @package.save
      redirect_to @package
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @package = Package.new
  end

  def destroy
    @package = current_user.packages.find(params[:id])
    @package.destroy

    redirect_to root_path
  end

  private

  def package_params
    params.require(:package).permit(:weight, :length, :width, :height,
                                    :start_point, :end_point)
  end

  def current_user_attributes
    { first_name: current_user.first_name, second_name: current_user.second_name,
      third_name: current_user.third_name, email: current_user.email,
      phone: current_user.phone }
  end

  def sort_column
    Package.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

end
