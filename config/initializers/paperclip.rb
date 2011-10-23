Paperclip.interpolates :filename do |attachment, style|
  attachment.instance.filename
end
Paperclip.options[:log] = true