class Place < ActiveRecord::Base
  has_many :events
  has_many :open_times, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :open_times, allow_destroy: true, reject_if: :all_blank

  # Ghost attributes from form
  attr_accessor :full_address

  # takes an address string and returns all location fields
  geocoded_by :full_address do |obj, result|
    if result.first
      geo = result.first
      obj.street = geo.street_address
      obj.city = geo.city
      obj.state = geo.state_code
      obj.zip = geo.postal_code
      obj.country = geo.country
      obj.neighborhood = geo.neighborhood
      obj.lat = geo.coordinates[0]
      obj.lng = geo.coordinates[1]
    end
  end

  reverse_geocoded_by :lat, :lng do |obj, result|
    if result.first
      geo = result.first
      obj.street = geo.street_address
      obj.city = geo.city
      obj.state = geo.state_code
      obj.zip = geo.postal_code
      obj.country = geo.country
      obj.neighborhood = geo.neighborhood
    end
  end


  after_validation :geocode #:reverse_geocode

  # form validations
  validates :name, presence: true
  # validates :description, presence: true
  # validates :address, presence: true
  #validate :event_date_cannot_be_in_the_past
  #validate :event_end_time_cannot_be_before_start_time

  # image upload properties
  has_attached_file :image, styles: {
    medium: '400x300#',
    banner: '338x100#',
    tiny: '140x140>',
    mini: '80x80!'
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # index search properties
  def self.search(search)
    where("name || description || neighborhood ILIKE ?", "%#{search}%")
  end

  def future_events
    instances = []
    Event.where(place: self).each do |e|
      instances << e.occurrences.where(date: Date.current..2.weeks.from_now)
    end
    instances.flatten!.sort_by(&:date) unless instances.empty?
  end

  # GEOCODING
  # def address
  #   unless read_attribute(:address).nil?
  #     [street, city, state, zip, country].compact.join(', ')
  #   end
  # end

  def address_changed?
    street_changed? || city_changed? || state_changed? || zip_changed? || country_changed?
  end
end
