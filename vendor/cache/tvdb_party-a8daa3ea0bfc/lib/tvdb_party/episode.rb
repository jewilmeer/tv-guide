module TvdbParty
  class Episode
    attr_accessor :id, :season_number, :number, :name, :overview, :air_date, :thumb, :guest_stars, :director, :writer, :series_id

    def initialize(options={})
      @id            = options["id"]
      @season_number = options["SeasonNumber"]
      @number        = options["EpisodeNumber"]
      @name          = options["EpisodeName"]
      @overview      = options["Overview"]
      @thumb         = "http://thetvdb.com/banners/" + options["filename"] if options["filename"].to_s != ""
      @director      = options["Director"]
      @writer        = options["Writer"]
      @series_id     = options['seriesid']

      if options["GuestStars"]
        @guest_stars = options["GuestStars"][1..-1].split("|")
      else
        @guest_stars = []
      end

      begin
        @air_date = Date.parse(options["FirstAired"])
      rescue
        @air_date = nil
      end
    end
  end
end