class Place < ActiveRecord::Base
	has_many :events

  accepts_nested_attributes_for :events, allow_destroy: true, reject_if: :all_blank

	# form validations
	validates :name, presence: true
	validates :description, presence: true
	validates :address, presence: true
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
end
