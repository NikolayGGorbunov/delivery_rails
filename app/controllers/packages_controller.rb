# frozen_string_literal: true

class PackagesController < ApplicationController
  def index
    @packages = Package.all
  end

  def show
    @package = Package.find(params[:id])
  end

  def create
    distance, price = Delivery::Deliveryboy.give_package(package_params).values_at(:distance, :price)
    @package = Package.new(package_params.merge!({ distance: distance, price: price }))

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
    @package = Package.find(params[:id])
    @package.destroy

    redirect_to root_path
  end

  private

  def package_params
    params.require(:package).permit(:first_name, :second_name, :third_name,
                                    :email, :phone, :weight, :length, :width, :height,
                                    :start_point, :end_point)
  end
end
