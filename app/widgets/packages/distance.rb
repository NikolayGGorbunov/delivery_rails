# frozen_string_literal: true

module Packages
  class Distance < DefaultWidget
    def self.call(org_id, func = :min)
      new(org_id).send(func)
    end

    private

    def min
      pack = @relation.order(:distance).first
      to_output(pack, 'Min')
    end

    def max
      pack = @relation.order(:distance).last
      to_output(pack, 'Max')
    end

    def to_output(input, grade)
      { text: "#{grade} distance of package: ", data: "Package№#{input.id} | #{input.distance}km" }
    end
  end
end
