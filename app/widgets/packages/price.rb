# frozen_string_literal: true

module Packages
  class Price < DefaultWidget
    def self.call(org_id, func = :all)
      new(org_id, :price).send(func)
    end

    private

    def all
      sum = @relation.count.map{ |price, mul| price * mul }.sum
      { text: 'Sum of all organization packages prices: ', data: sum }
    end

    def average
      package_prices = @relation.count
      result = package_prices.map{ |price, mul| price * mul }.sum / package_prices.values.sum
      { text: 'Average from all organization packages prices: ', data: result }
    end
  end
end
