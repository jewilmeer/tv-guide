Paperclip.interpolates :filename do |attachment, style|
  attachment.instance.filename
end
Paperclip.options[:log] = true

Paperclip.interpolates :timestamp do |attachment, style|
  attachment.instance_read(:updated_at).to_i
end

# stupic hack to prevent peperclips broken spoof protection
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end