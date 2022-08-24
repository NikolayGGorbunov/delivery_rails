# frozen_string_literal: true

require 'net/http'
module Delivery
  class Deliveryboy
    def self.give_package(hsh = {})
      hsh = hash_modifier(hsh)
      parsed_geo = get_geocode_parsed(hsh[:start_point], hsh[:end_point])
      parsed_distance = get_distance_parsed(get_cities_cords(parsed_geo))
      distance = distance_to_km(get_distance(parsed_distance))
      price_mul = package_type(hsh[:weight], hsh[:length], hsh[:width], hsh[:height])
      hsh.slice(:weight, :length, :width, :height).merge!({ distance: distance, price: distance * price_mul })
    end

    def self.hash_modifier(hash)
      mod_to_i = hash.slice(:length, :width, :height).transform_values!(&:to_i)
      mod_to_f = hash.slice(:weight).transform_values!(&:to_f)
      mod_downcase = hash.slice(:start_point, :end_point).transform_values!(&:downcase)
      hash.merge!(mod_downcase) { |_key, _old, new| new }
      hash.merge!(mod_to_i) { |_key, _old, new| new }
      hash.merge!(mod_to_f) { |_key, _old, new| new }
    end

    def self.get_geocode_parsed(city1, city2)
      city1 = city1.downcase
      city2 = city2.downcase
      raise "City name can't be empty" if city1.blank? || city2.blank?
      raise 'Choose different cities' if city1 == city2

      uri = URI("https://api.mapbox.com/geocoding/v5/mapbox.places/#{city1}%2C#{city2}.json?country=ru&limit=2&proximity=ip&types=place&access_token=#{ENV['MAPBOX_KEY']}")
      JSON.parse(Net::HTTP.get(uri))
    end

    def self.get_distance_parsed(cords_arr)
      cords1, cords2 = cords_arr
      uri = URI("https://api.mapbox.com/directions/v5/mapbox/driving/#{cords1[0]}%2C#{cords1[1]}%3B#{cords2[0]}%2C#{cords2[1]}?alternatives=false&geometries=geojson&overview=simplified&steps=false&access_token=#{ENV['MAPBOX_KEY']}")
      JSON.parse(Net::HTTP.get(uri))
    end

    def self.get_cities_cords(p_cities)
      raise 'City not found' if p_cities['features'].size < 2

      [p_cities['features'][0]['center'], p_cities['features'][1]['center']]
    end

    def self.get_distance(p_cords)
      raise 'No route' if p_cords['code'].include?('NoSegment') || p_cords['code'].include?('NoRoute')

      p_cords['routes'].first['distance']
    end

    def self.distance_to_km(distance)
      (distance / 1000).round
    end

    def self.package_type(weight, length, width, height)
      raise 'Wrong arguments' if weight.negative? || length <= 0 || width <= 0 || height <= 0

      if length * width * height < 1_000_000
        1
      elsif weight <= 10
        2
      else
        3
      end
    end

    private_class_method :hash_modifier, :get_geocode_parsed, :get_distance_parsed,
                         :get_cities_cords, :get_distance, :distance_to_km, :package_type
  end
end
