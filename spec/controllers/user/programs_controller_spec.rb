require 'spec_helper'

describe ::User::ProgramsController do
  describe "routes" do
    it "should route personal guide rss feed" do
      { get: "/user/jewilmeer/programs/t/sometoken.rss"}.should route_to \
      "user/programs#aired",
      user_id: 'jewilmeer',
      authentication_token: 'sometoken',
      format: 'rss'
    end
  end
end