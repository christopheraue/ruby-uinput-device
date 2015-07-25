# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uinput/device/version'

Gem::Specification.new do |spec|
  spec.name          = "uinput-device"
  spec.version       = Uinput::Device::VERSION
  spec.authors       = ["Christopher Aue"]
  spec.email         = ["mail@christopheraue.net"]

  spec.summary       = %q{Generic ruby wrapper around uinput to create devices.}
  spec.homepage      = "https://github.com/christopheraue/ruby-uinput-device"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "uinput", "~> 1.0"
  spec.add_runtime_dependency 'ffi-libc', '~> 0.1.0'
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
