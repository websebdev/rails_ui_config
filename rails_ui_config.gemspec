require_relative "lib/rails_ui_config/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_ui_config"
  spec.version     = RailsUiConfig::VERSION
  spec.authors     = ["Sebastien Auriault"]
  spec.email       = ["sebastienauriault@gmail.com"]
  spec.homepage    = "https://github.com/websebdev/rails_ui_config"
  spec.summary     = "summary"
  spec.description = "description"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/websebdev/rails_ui_config"
  spec.metadata["changelog_uri"] = "https://github.com/websebdev/rails_ui_config/changelog.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.2"
  spec.add_dependency "rails", ">= 6.1.3.2"
  spec.add_dependency "parser", "~> 3.0", ">= 3.0.1.1"
  spec.add_dependency "rubocop-ast"
  spec.add_dependency "rubocop"
end
