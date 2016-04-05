class Conversation < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy
  has_and_belongs_to_many :tags

  enum state: [ :new_request, :discovery_method, :local_or_visitor, :when, :what ]
end
