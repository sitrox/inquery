# -*- encoding: utf-8 -*-
# stub: inquery 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "inquery"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sitrox"]
  s.date = "2016-06-08"
  s.files = [".gitignore", ".releaser_config", ".rubocop.yml", ".travis.yml", ".yardopts", "Gemfile", "LICENSE", "README.md", "RUBY_VERSION", "Rakefile", "VERSION", "doc/Inquery.html", "doc/Inquery/Exceptions.html", "doc/Inquery/Exceptions/Base.html", "doc/Inquery/Exceptions/InvalidRelation.html", "doc/Inquery/Exceptions/UnknownCallSignature.html", "doc/Inquery/Mixins.html", "doc/Inquery/Mixins/RelationValidation.html", "doc/Inquery/Mixins/RelationValidation/ClassMethods.html", "doc/Inquery/Mixins/SchemaValidation.html", "doc/Inquery/Mixins/SchemaValidation/ClassMethods.html", "doc/Inquery/Query.html", "doc/Inquery/Query/Chainable.html", "doc/_index.html", "doc/class_list.html", "doc/css/common.css", "doc/css/full_list.css", "doc/css/style.css", "doc/file.README.html", "doc/file_list.html", "doc/frames.html", "doc/index.html", "doc/js/app.js", "doc/js/full_list.js", "doc/js/jquery.js", "doc/method_list.html", "doc/top-level-namespace.html", "inquery.gemspec", "lib/inquery.rb", "lib/inquery/exceptions.rb", "lib/inquery/mixins/relation_validation.rb", "lib/inquery/mixins/schema_validation.rb", "lib/inquery/query.rb", "lib/inquery/query/chainable.rb", "test/db/models.rb", "test/db/schema.rb", "test/inquery/query/chainable_test.rb", "test/inquery/query_test.rb", "test/queries/group/fetch_as_json.rb", "test/queries/group/fetch_green.rb", "test/queries/group/fetch_red.rb", "test/queries/user/fetch_all.rb", "test/queries/user/fetch_in_group.rb", "test/queries/user/fetch_in_group_rel.rb", "test/test_helper.rb"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "A skeleton that allows extracting queries into atomic, reusable classes."
  s.test_files = ["test/db/models.rb", "test/db/schema.rb", "test/inquery/query/chainable_test.rb", "test/inquery/query_test.rb", "test/queries/group/fetch_as_json.rb", "test/queries/group/fetch_green.rb", "test/queries/group/fetch_red.rb", "test/queries/user/fetch_all.rb", "test/queries/user/fetch_in_group.rb", "test/queries/user/fetch_in_group_rel.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["= 0.35.1"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_runtime_dependency(%q<minitest>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<schemacop>, [">= 1.0.1"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["= 0.35.1"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<schemacop>, [">= 1.0.1"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["= 0.35.1"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<schemacop>, [">= 1.0.1"])
  end
end