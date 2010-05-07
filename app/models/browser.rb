class Browser
  def self.agent
    Mechanize.html_parser = Nokogiri::HTML
    Mechanize.new
  end
end