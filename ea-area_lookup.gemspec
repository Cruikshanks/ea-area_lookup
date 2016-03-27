# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ea/area_lookup/version"

Gem::Specification.new do |spec|
  spec.name          = "ea-area_lookup"
  spec.version       = EA::AreaLookup::VERSION
  spec.authors       = ["Digital Services Team, EnvironmentAgency"]
  spec.email         = ["dst@environment-agency.gov.uk"]

  spec.summary       = "Provides a means of looking-up Environment Agency administrative areas."
  spec.description   = "Provides a means of looking-up an Environment Agency administrative area "\
                       "using the co-ordinates of any point in England."
  spec.homepage      = "https://github.com/EnvironmentAgency"
  spec.license       = "The Open Government Licence (OGL) Version 3"

  spec.required_ruby_version = '>= 2.2'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.3"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency  "vcr", "~> 3.0"
  spec.add_development_dependency  "webmock", "~> 1.24"
  spec.add_development_dependency  "shoulda-matchers", "~> 3.1"
  spec.add_development_dependency  "simplecov"
  spec.add_development_dependency  "before_commit"
end
