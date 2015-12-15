class Event < ActiveRecord::Base
	has_attached_file :image, styles: {
		medium: '300x300>',
		tiny: '140x140>',
		mini: '80x80!'
	}
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	def self.search(search)
	  where("title || description || date || neighborhood LIKE ?", "%#{search}%")
	end
end