# This file is used by Rack-based servers to start the application.

GC::Profiler.enable

require ::File.expand_path('../config/environment',  __FILE__)
run TvEpisodes::Application
