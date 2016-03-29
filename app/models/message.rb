class Message < ActiveRecord::Base
  belongs_to :conversation, counter_cache: true
end
