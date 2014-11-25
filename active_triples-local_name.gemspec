# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_triples/local_name/version"

Gem::Specification.new do |s|
  s.name        = "active_triples-local_name"
  s.version     = ActiveTriples::LocalName::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["E. Lynette Rayle"]
  s.homepage    = 'https://github.com/no-reply/active_triples-local_name'
  s.email       = 'elr37@cornell.edu'
  s.summary     = %q{Local name minter for ActiveTriples based resources.}
  s.description = %q{active_triples-local_name provides a standard interface and default implementation for a minter of the local name portion of a URI.}
  s.license     = "APACHE2"
  s.required_ruby_version     = '>= 1.9.3'

  # GETTING FROM GEMFILE UNTIL persistent check CODE IS RELEASED
  # s.add_dependency('active-triples', '~> 0.4')

  s.add_dependency('deprecation', '~> 0.1')
  s.add_dependency('activesupport', '>= 3.0.0')

  s.add_development_dependency('rdoc')
  s.add_development_dependency('rspec')
  s.add_development_dependency('guard-rspec')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")

  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
end
