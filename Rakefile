task :gemspec do
  gemspec = Gem::Specification.new do |spec|
    spec.name          = 'inquery'
    spec.version       = File.read('VERSION').chomp
    spec.authors       = ['Sitrox']
    spec.homepage      = 'https://github.com/sitrox/inquery'
    spec.summary       = %(
      A skeleton that allows extracting queries into atomic, reusable classes.
    )
    spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
    spec.executables   = []
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ['lib']

    spec.add_development_dependency 'appraisal'
    spec.add_development_dependency 'rake'
    spec.add_development_dependency 'simplecov'
    spec.add_development_dependency 'sqlite3'
    spec.add_development_dependency 'haml'
    spec.add_development_dependency 'yard'
    spec.add_development_dependency 'rubocop', '1.25'
    spec.add_development_dependency 'redcarpet'
    spec.add_dependency 'minitest'
    spec.add_dependency 'activesupport'
    spec.add_dependency 'activerecord'
    spec.add_dependency 'schemacop', '~> 3.0.8'
  end

  File.write('inquery.gemspec', gemspec.to_ruby.strip)
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/inquery/**/*_test.rb'
  t.verbose = false
  t.libs << 'test'
end
