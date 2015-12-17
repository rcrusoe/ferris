class Event < ActiveRecord::Base
	# form validations
	validates :title, presence: true
	validates :short_blurb, presence: true
	validates :description, presence: true
	validates :address, presence: true
	validates :price, numericality: { only_integer: true }
	validate :event_date_cannot_be_in_the_past
	validate :event_end_time_cannot_be_before_start_time

	def event_date_cannot_be_in_the_past
	  if date.present? && date < Date.today
	      errors.add(:date, "can't be in the past")
	  end
	end

	def event_end_time_cannot_be_before_start_time
	    if end_time < start_time
	      errors.add(:end_time, "can't be before start time.")
	    end
	end

	# image upload properties
	has_attached_file :image, styles: {
		medium: '400x400>',
		banner: '338x100#',
		tiny: '140x140>',
		mini: '80x80!'
	}
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	# index search properties
	def self.search(search)
	  where("title || description || date || neighborhood ILIKE ?", "%#{search}%")
	end

  	before_save :sanitize_website, :sanitize_purchase_url

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