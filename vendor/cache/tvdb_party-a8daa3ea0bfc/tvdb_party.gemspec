# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "tvdb_party"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jon Maddox"]
  s.date = "2010-11-19"
  s.description = "Simple Ruby library to talk to thetvdb.com's api"
  s.email = "jon@mustacheinc.com"
  s.extra_rdoc_files = ["LICENSE", "README.textile"]
  s.files = [".document", ".gitignore", "LICENSE", "README.textile", "Rakefile", "VERSION", "lib/tvdb_party.rb", "lib/tvdb_party/actor.rb", "lib/tvdb_party/banner.rb", "lib/tvdb_party/episode.rb", "lib/tvdb_party/httparty_icebox.rb", "lib/tvdb_party/search.rb", "lib/tvdb_party/series.rb", "test/test_helper.rb", "test/tvdb_party_test.rb", "tvdb_party.gemspec"]
  s.homepage = "http://github.com/maddox/tvdb_party"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Simple Ruby library to talk to thetvdb.com's api"
  s.test_files = ["test/test_helper.rb", "test/tvdb_party_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, [">= 0.6.1"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0.6.1"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0.6.1"])
  end
end