# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_chartkick/version'

Gem::Specification.new do |spec|
  spec.name          = "my_chartkick"
  spec.version       = MyChartkick::VERSION
  spec.authors       = ["ken"]
  spec.email         = ["block24block@gmail.com"]

  spec.summary       = 'A Chartkick wrapper works with non-activerecord'
  spec.homepage      = "https://github.com/turnon/my_chartkick"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "chartkick", "~> 2.2.3"
  spec.add_dependency "rand_palette", "~> 0.1.2"
  spec.add_dependency "activesupport", "> 3.0.0"
end
