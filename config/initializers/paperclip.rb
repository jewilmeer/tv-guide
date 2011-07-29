Paperclip.interpolates :filename do |attachment, style|
  attachment.instance.filename
end
Paperclip.options[:log] = true

if ENV['steef']
  Paperclip.options[:command_path] = 'C:\Program Files\ImageMagick-6.7.1-Q16'
  Paperclip.options[:swallow_stderr] = false
end