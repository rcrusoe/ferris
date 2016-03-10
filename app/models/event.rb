class Event < ActiveRecord::Base
	before_save :sanitize_website, :sanitize_purchase_url
  after_create :generate_recurrences

  has_many :occurrences, -> { order(date: :asc) }
  belongs_to :place

  serialize :recurrence, Hash

	# form validations
	validates :title, presence: true
	validates :short_blurb, presence: true
	validates :description, presence: true
	validates :address, presence: true
	validates :price, numericality: { only_integer: true }
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

  # parse recurrence and save as schedule
  def recurrence=(new_rule)
    if RecurringSelect.is_valid_rule?(new_rule)
      rule = RecurringSelect.dirty_hash_to_rule(new_rule).to_hash
      s = IceCube::Schedule.new(now = Time.current.beginning_of_day)
      s.add_recurrence_rule(rule)
      write_attribute(:recurrence, s.to_hash)
    else
      write_attribute(:recurrence, nil)
    end
  end

  # custom getter to convert hash into schedule
  def recurrence
    schedule = IceCube::Schedule.from_hash(read_attribute(:recurrence))
    schedule.start_time = Time.current.beginning_of_day
    schedule
  end

  # create occurrences for repeating events
  def generate_recurrences
    # get a list of all occurrences for the next 30 days
    # for each occurrence
      # create with the date, grab start and end time from base object
  end

  # convert hash to schedule object when accessing attribute
  # def recurrence
  #
  # end

	# index search properties
	def self.search(search)
	  where("title || description || date || neighborhood ILIKE ?", "%#{search}%")
	end

	def sanitize_website
	  unless self.website.include?("http://") || self.website.include?("https://")
	      self.website = "http://" + self.website
	  end
	end

	def sanitize_purchase_url
	  unless self.purchase_url.include?("http://") || self.purchase_url.include?("https://")
	      self.purchase_url = "http://" + self.purchase_url
	  end
  end
end