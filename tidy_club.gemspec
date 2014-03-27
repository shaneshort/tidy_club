# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tidy_club/version'

Gem::Specification.new do |spec|
  spec.name = "tidy_club"
  spec.version = TidyClub::VERSION
  spec.authors = ["Jason Playne"]
  spec.email = ["jason@jasonplayne.com"]
  spec.summary = %q{TODO: Write a short summary. Required.}
  spec.description = %q{TODO: Write a longer description. Optional.}
  spec.homepage = ""
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "json"
  #spec.add_development_dependency "logger"
  #spec.add_development_dependency "net/https"
  #spec.add_development_dependency "uri"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
