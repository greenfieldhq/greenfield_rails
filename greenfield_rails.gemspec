# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'greenfield_rails/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{GreenfieldRails::RUBY_VERSION}"
  s.authors = ['Greenfield']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Greenfield Rails is a base Rails project.
  HERE

  s.email = 'dave@greenfieldhq.com'
  s.executables = ['greenfield_rails']
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/greenfieldhq/greenfield_rails'
  s.license = 'MIT'
  s.name = 'greenfield_rails'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app like Greenfield."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = GreenfieldRails::VERSION

  s.add_dependency 'bundler', '~> 1.7'
  s.add_dependency 'rails', GreenfieldRails::RAILS_VERSION
end
