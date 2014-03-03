# -*- encoding: utf-8 -*-
require File.expand_path("../lib/storys/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "storys"
  s.version     = Storys::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Brenton "B-Train" Fletcher']
  s.email       = ["i@bloople.net"]
  s.homepage    = "http://github.com/bloopletech/storys"
  s.summary     = "Storys indexes a collection of stories and generates a SPA that browses the collection."
  s.description = "A collection of stories is a directory (the container) containing 1..* HTML files (stories). Storys indexes a collection in this format, and generates a HTML/JS Single Page Application (SPA) that allows you to browse and view stories in your collection. The SPA UI is much easier to use than using a filesystem browser; and the SPA, along with the collection can be trivially served over a network by putting the collection and the SPA in a directory served by nginx or Apache."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "storys"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.14.1"
  s.add_development_dependency "factory_girl", ">= 4.4.0"
  s.add_dependency "addressable", ">= 2.3.5"
  s.add_dependency "naturally", ">= 1.0.3"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
