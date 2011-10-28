Paperclip.interpolates :filename do |attachment, style|
  attachment.instance.filename
end
Paperclip.options[:log] = true

Paperclip.interpolates :timestamp do |attachment, style|
  attachment.instance_read(:updated_at).to_i  
end