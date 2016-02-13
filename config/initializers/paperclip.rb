# config/initializers/paperclip.rb

require 'paperclip/copy_attachments'
ActiveRecord::Base.send :include, Paperclip::CopyAttachments