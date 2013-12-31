# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundler'
require 'bird/version'

Gem::Specification.new do |s|
  s.name        = "bird"
  s.version     = Bird::VERSION
  s.authors     = ["Brett Swift"]
  s.email       = ["brettswift@gmail.com"]
  s.homepage    = "http://brettswift.github.com/bird/"
  s.summary     = %q{Control vCloud and Puppet Deployments}
  s.description = %q{Provision a VM, and kick puppet!}
  s.license     = "MIT"

  # s.rubyforge_project = "bird"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "rr"
  s.add_development_dependency "fakefs"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "user_config"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "vcloud-rest"
end
