# coding: utf-8

version = File.read(File.expand_path("VERSION", __dir__)).strip

Gem::Specification.new do |spec|
  spec.name          = "superconfig2"
  spec.version       = version
  spec.authors       = ["Jon Bardin"]
  spec.email         = ["diclophis@gmail.com"]

  spec.summary       = %q{12factor ENV helper}
  spec.description   = %q{Conventional ENV application configuration}
  spec.homepage      = "https://github.com/diclophis/superconfig2"

  spec.license       = "BSD"

  spec.files         = Dir.glob("lib/**/*")
  spec.bindir        = ["bin"]
  spec.executables   = ["superconfig2"]
  spec.require_paths = ["lib"]
end
