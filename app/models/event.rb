class Event < ActiveRecord::Base
	has_attached_file :image, styles: {
		medium: '300x300>',
		small: '150x150>',
		tiny: '80x80!'
	}
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

end
