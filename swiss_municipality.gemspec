Gem::Specification.new do |specification|
  specification.name = "swiss_municipality"
  specification.version = "0.1.2"
  specification.authors = ["Denis Müller"]
  specification.email = ["denis@synerma.ch"]
  specification.summary = "A gem to map swiss municipalities to zip codes and cantons."
  specification.description = specification.summary
  specification.files = ["lib/swiss_municipality.rb", "lib/swiss_municipality/municipality_data.rb"]
  specification.homepage = "https://rubygems.org/gems/swiss_municipality"
  specification.license = "MIT"

  specification.add_development_dependency 'rspec', '~> 3.12'
end