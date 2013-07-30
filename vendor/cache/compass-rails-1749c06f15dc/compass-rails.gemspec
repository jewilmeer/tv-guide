# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "compass-rails"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Scott Davis", "Chris Eppstein"]
  s.date = "2013-07-30"
  s.description = "Integrate Compass into Rails 2.3 and up."
  s.email = ["jetviper21@gmail.com", "chris@eppsteins.net"]
  s.files = [".gitignore", ".travis.yml", "Appraisals", "Gemfile", "Guardfile", "LICENSE", "README.md", "Rakefile", "changelog.markdown", "compass-rails.gemspec", "gemfiles/rails2.gemfile", "gemfiles/rails2.gemfile.lock", "gemfiles/rails3.gemfile", "gemfiles/rails3.gemfile.lock", "gemfiles/rails31.gemfile", "gemfiles/rails31.gemfile.lock", "gemfiles/rails32.gemfile", "gemfiles/rails32.gemfile.lock", "gemfiles/rails40.gemfile", "lib/compass-rails.rb", "lib/compass-rails/configuration.rb", "lib/compass-rails/configuration/3_1.rb", "lib/compass-rails/configuration/default.rb", "lib/compass-rails/installer.rb", "lib/compass-rails/patches.rb", "lib/compass-rails/patches/3_1.rb", "lib/compass-rails/patches/importer.rb", "lib/compass-rails/patches/sprite_importer.rb", "lib/compass-rails/patches/static_compiler.rb", "lib/compass-rails/railties.rb", "lib/compass-rails/railties/2_3.rb", "lib/compass-rails/railties/3_0.rb", "lib/compass-rails/railties/3_1.rb", "lib/compass-rails/version.rb", "test/fixtures/.gitkeep", "test/helpers/command_helper.rb", "test/helpers/debug_helper.rb", "test/helpers/file_helper.rb", "test/helpers/rails_helper.rb", "test/helpers/rails_project.rb", "test/integrations/.gitkeep", "test/integrations/rails3_test.rb", "test/integrations/rails_23_test.rb", "test/integrations/rails_31_test.rb", "test/integrations/rails_32_test.rb", "test/integrations/rails_40_test.rb", "test/test_helper.rb", "test/units/.gitkeep"]
  s.homepage = "https://github.com/Compass/compass-rails"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.2"
  s.summary = "Integrate Compass into Rails 2.3 and up."
  s.test_files = ["test/fixtures/.gitkeep", "test/helpers/command_helper.rb", "test/helpers/debug_helper.rb", "test/helpers/file_helper.rb", "test/helpers/rails_helper.rb", "test/helpers/rails_project.rb", "test/integrations/.gitkeep", "test/integrations/rails3_test.rb", "test/integrations/rails_23_test.rb", "test/integrations/rails_31_test.rb", "test/integrations/rails_32_test.rb", "test/integrations/rails_40_test.rb", "test/test_helper.rb", "test/units/.gitkeep"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<compass>, ["< 0.14", ">= 0.12.2"])
    else
      s.add_dependency(%q<compass>, ["< 0.14", ">= 0.12.2"])
    end
  else
    s.add_dependency(%q<compass>, ["< 0.14", ">= 0.12.2"])
  end
end
