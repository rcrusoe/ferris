class Conversation < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :messages
  has_and_belongs_to_many :tags
end
