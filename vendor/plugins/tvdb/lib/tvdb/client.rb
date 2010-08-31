module TVdb
  class Client
    attr_reader :api_key, :urls
    
    def initialize(api_key)
      @api_key = api_key
      @urls = Urls.new(api_key)
    end
    
    def search(name, options={})
      default_options = {:lang => 'en', :match_mode => :all}
      options         = default_options.merge(options)
      search_url      = @urls[:get_series] % {:name => URI.escape(name), :language => options[:lang]}
      doc             = Hpricot(OpenURI.open_uri(search_url).read)
      
      ids = if options[:match_mode] == :exact
        doc.search('series').select{|s| s.search('seriesname').inner_text.downcase == name.downcase }.collect{|e| e.search('id')}.map(&:inner_text)
      else
        doc.search('series').search('id').map(&:inner_text)
      end
      
      ids.map do |sid|
        # get_serie_from_zip(sid, options[:lang])
        get_program_info(sid, options[:lang])
      end.compact
    end

    def get_episodes(id)
      xml      = open_or_rescue( @urls[:serie_full_xml] % {:serie_id => id, :language => 'en' } )
      doc      = Hpricot.XML xml
      episodes = []
      doc.search('Episode').select do |e|
        episodes << Hash.from_xml( e.to_s )['Episode']
      end
      episodes
    end
    
    def get_banners(id)
      banners = []
      doc = Hpricot.XML(open_or_rescue( @urls[:banners_xml] % {:serie_id => id} ))
      doc.search('banner').select do |e|
        banners << {
          :id         => e.search('id').inner_html,
          :path       => e.search('bannerpath').inner_html,
          :type       => e.search('bannertype').inner_html,
          :subtype    => e.search('bannertype2').inner_html
        }
        banners
      end
      banners
    end
        
    def serie_in_language(serie, lang = 'en')
      return nil if !serie.respond_to?(:tvdb_id)
      return serie if lang == serie.language
      
      get_serie_from_zip(serie.tvdb_id, lang)
    end
    
    def get_serie_zip(id, lang='en')
      zip_file = open_or_rescue(@urls[:serie_zip] % {:serie_id => id, :language => lang})
      puts zipfile
      zip_file.nil? ? nil : Zip::ZipFile.new(zip_file.path)
    end
    
    private
    
    def open_or_rescue(url)
      begin
        Rails.logger.debug "Opening #{url}"
        return OpenURI.open_uri(url)
      rescue OpenURI::HTTPError # 404 errors for some of the ids returned in search
        return nil
      end
    end
    
    def get_program_info(sid, lang='en')
      doc = open_or_rescue( @urls[:serie_xml] % {:serie_id => sid, :language => lang} )
      Hash.from_xml( Hpricot.XML( doc ).search('Series').to_s )['Series']
    end
    
    def get_serie_from_zip(sid, lang='en')
      zip = get_serie_zip(sid, lang)
      return nil if zip.nil?
      
      xml = read_serie_xml_from_zip(zip, lang)
      return xml ? Serie.new(xml) : nil
    end
    
    def read_serie_xml_from_zip(zip, lang='en')
      if entry = zip.find_entry("#{lang}.xml")
        entry.get_input_stream.read
      end
    end
  end
end