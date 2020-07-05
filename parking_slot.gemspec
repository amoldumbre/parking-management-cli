require_relative 'lib/parking_slot/version'

Gem::Specification.new do |spec|
  spec.name          = "parking_slot"
  spec.version       = ParkingSlot::VERSION
  spec.authors       = ["Amol Dumbre"]
  spec.email         = ["dev.amold@gmail.com"]

  spec.summary       = "Vehicle parking management through CLI"
  spec.description   = "Vehicle parking management through Ruby-Command Line Interface"
  spec.homepage      = "https://amoldumbre.github.io/"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "Set to 'https://amoldumbre.github.io/' "

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://amoldumbre.github.io/"
  spec.metadata["changelog_uri"] = "https://amoldumbre.github.io/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "thor", "~> 0.20"
  spec.add_dependency "sqlite3"
  spec.add_dependency "console_table"
  spec.add_dependency "colorize"

end
