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

    spec.add_dependency 'activesupport', '>= 5.1'
    spec.add_dependency 'activerecord', '>= 5.1'
    spec.add_dependency 'schemacop', '>= 3.0.8', '< 4.0'
  end

  File.write('inquery.gemspec', gemspec.to_ruby.strip)
end

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = 'test/inquery/**/*_test.rb'
  t.verbose = false
  t.libs << 'test'
end
