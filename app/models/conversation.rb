class Conversation < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :tags
end
