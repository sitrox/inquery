# -*- encoding: utf-8 -*-
# stub: inquery 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "inquery"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sitrox"]
  s.date = "2016-06-07"
  s.files = [".gitignore", ".releaser_config", ".rubocop.yml", ".yardopts", "Gemfile", "LICENSE", "RUBY_VERSION", "Rakefile", "VERSION", "inquery.gemspec", "lib/inquery.rb", "lib/inquery/exceptions.rb", "lib/inquery/mixins/relation_validation.rb", "lib/inquery/mixins/schema_validation.rb", "lib/inquery/query.rb", "lib/inquery/query/chainable.rb", "test/db/models.rb", "test/db/schema.rb", "test/inquery/query/chainable_test.rb", "test/inquery/query_test.rb", "test/queries/fetch_all_users.rb", "test/queries/fetch_groups_as_json.rb", "test/queries/fetch_users_in_group.rb", "test/queries/fetch_users_in_group_rels.rb", "test/test_helper.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "A skeleton that allows extracting queries into atomic, reusable classes."
  s.test_files = ["test/db/models.rb", "test/db/schema.rb", "test/inquery/query/chainable_test.rb", "test/inquery/query_test.rb", "test/queries/fetch_all_users.rb", "test/queries/fetch_groups_as_json.rb", "test/queries/fetch_users_in_group.rb", "test/queries/fetch_users_in_group_rels.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, ["~> 4.0.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["= 0.35.1"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_runtime_dependency(%q<minitest>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<schemacop>, ["~> 1.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activerecord>, ["~> 4.0.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["= 0.35.1"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<schemacop>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activerecord>, ["~> 4.0.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["= 0.35.1"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<schemacop>, ["~> 1.0"])
  end
end