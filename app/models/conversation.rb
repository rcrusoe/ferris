class Conversation < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
  has_and_belongs_to_many :tags
end
