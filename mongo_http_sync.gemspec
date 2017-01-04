# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongo_http_sync/version'

Gem::Specification.new do |spec|
  spec.name          = "mongo_http_sync"
  spec.version       = MongoHTTPSync::VERSION
  spec.authors       = ["André Aizim Kelmanson"]
  spec.email         = ["akelmanson@gmail.com"]

  spec.summary       = %q{MongoDB HTTP Synchronizer}
  spec.description   = %q{Synchronizes HTTP services with MongoDB}
  spec.homepage      = "https://github.com/investtools/mongo_http_sync"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "webmock"
  spec.add_dependency "mongoid"
  spec.add_dependency "oj"
  spec.add_dependency "http"
  spec.add_dependency "grape-entity"
end
