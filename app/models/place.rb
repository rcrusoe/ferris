class Place < ActiveRecord::Base
  has_many :events
  has_many :open_times, dependent: :destroy
  has_and_belongs_to_many :tags

  accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :open_times, allow_destroy: true, reject_if: :all_blank

  geocoded_by :address, :latitude  => :lat, :longitude => :lng

  reverse_geocoded_by :lat, :lng do |obj, geo|
    obj.neighborhood = geo.first.neighborhood
  end

  after_validation :geocode, :reverse_geocode, if: :address_changed?

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
  def address
    [street, city, state, zip, country].compact.join(', ')
  end

  def address_changed?
    street_changed? || city_changed? || state_changed? || zip_changed? || country_changed?
  end
end
