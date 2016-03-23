class Location < ActiveRecord::Base
  belongs_to :place

  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  reverse_geocoded_by :lat, :lng do |obj, geo|
    obj.neighborhood = geo.first.neighborhood
  end

  after_validation :geocode, :reverse_geocode, if: :address_changed?

  def address
    [street, city, state, zip, country].compact.join(', ')
  end

  def address_changed?
    street_changed? || city_changed? || state_changed? || zip_changed? || country_changed?
  end
end
