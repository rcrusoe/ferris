class User < ActiveRecord::Base
	validates :phone_number, presence: true
end
