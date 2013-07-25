# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "burlesque/version"

Gem::Specification.new do |s|
  s.name        = "burlesque"
  s.version     = Burlesque::VERSION
  s.authors     = ["mespina"]
  s.email       = ["mespina.icc@gmail.com"]
  s.homepage    = ""
  s.summary     = "Roles y Grupos"
  s.description = "Crea estructura de roles y grupos para caulquier modelo, considera ademas las 3 tablas de join que pudiesen darse"

  s.rubyforge_project = "burlesque"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.12"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
