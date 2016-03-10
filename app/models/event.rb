class Event < ActiveRecord::Base
  before_save :sanitize_urls
  after_save :generate_recurrences

  has_many :occurrences, -> { order(date: :asc) }, dependent: :destroy
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
      write_attribute(:recurrence, rule)
    else
      write_attribute(:recurrence, nil)
    end
  end

  # custom getter to convert hash into schedule
  def recurrence
    unless read_attribute(:recurrence).empty?
      IceCube::Rule.from_hash(read_attribute(:recurrence))
    end
  end

  # on creation or update, generate event instances
  def generate_recurrences
    unless read_attribute(:recurrence).empty?
      # remove all already scheduled occurrences in the future
      Occurrence.where('event_id = ? AND date >= ?', self.id, Date.current).delete_all

      # schedule events for the next month
      # TODO: make instance variable with schedule instance to avoid repeat instantiation
      schedule = IceCube::Schedule.new
      schedule.add_recurrence_rule(self.recurrence)
      schedule.occurrences(Time.current + 1.month).each do |o|
        Occurrence.create(event: self,
                          date: o.to_date)
      end
    else
      Occurrence.create(event: self, date: self.date)
    end
  end

  def recurring?
    self.recurrence
  end

	# index search properties
	def self.search(search)
	  where('title || description || date || neighborhood ILIKE ?', "%#{search}%")
	end

	def sanitize_urls
	  unless self.website.include?('http://') || self.website.include?('https://')
	      self.website = 'http://' + self.website
    end

    unless self.purchase_url.include?('http://') || self.purchase_url.include?('https://')
      self.purchase_url = 'http://' + self.purchase_url
    end
  end

end