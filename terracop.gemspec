# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'terracop/version'

Gem::Specification.new do |spec|
  spec.name          = 'terracop'
  spec.version       = Terracop::VERSION
  spec.authors       = ['Francesco Boffa']
  spec.email         = ['fra.boffa@gmail.com']

  spec.summary       = 'Automatic Terraform state/plan checking tool'
  spec.description   = <<-DESCRIPTION
    Automatic Terraform state/plan checking tool.
    Aims to enforce best practices for Terraform and "the cloud".
  DESCRIPTION

  spec.homepage = 'https://github.com/aomega08/terracop'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.78'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.37'
  spec.add_development_dependency 'simplecov', '~> 0.10'

  spec.add_dependency 'colorize', '~> 0.8'
end
