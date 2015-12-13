class Event < ActiveRecord::Base
	validates :title, presence: true
	validates :description, presence: true
	validates :date, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
	validates :address, presence: true
	validates :website, presence: true
	validates :price, presence: true
end
