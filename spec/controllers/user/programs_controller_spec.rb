require 'spec_helper'

describe ::User::ProgramsController do


  describe "routes" do
    it "should route personal guide rss feed" do
      { get: "/user/jewilmeer/programs/t/sometoken.rss"}.should route_to \
      controller: "user/programs",
      action: 'aired',
      user_id: 'jewilmeer', 
      user_credentials: 'sometoken'
    end
  end
end