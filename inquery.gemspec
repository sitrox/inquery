# -*- encoding: utf-8 -*-
# stub: inquery 1.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "inquery".freeze
  s.version = "1.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sitrox".freeze]
  s.date = "2021-02-24"
  s.files = [".gitignore".freeze, ".releaser_config".freeze, ".rubocop.yml".freeze, ".travis.yml".freeze, ".yardopts".freeze, "CHANGELOG.md".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "RUBY_VERSION".freeze, "Rakefile".freeze, "VERSION".freeze, "doc/Inquery.html".freeze, "doc/Inquery/Exceptions.html".freeze, "doc/Inquery/Exceptions/Base.html".freeze, "doc/Inquery/Exceptions/InvalidRelation.html".freeze, "doc/Inquery/Exceptions/UnknownCallSignature.html".freeze, "doc/Inquery/Mixins.html".freeze, "doc/Inquery/Mixins/RawSqlUtils.html".freeze, "doc/Inquery/Mixins/RelationValidation.html".freeze, "doc/Inquery/Mixins/RelationValidation/ClassMethods.html".freeze, "doc/Inquery/Mixins/SchemaValidation.html".freeze, "doc/Inquery/Mixins/SchemaValidation/ClassMethods.html".freeze, "doc/Inquery/Query.html".freeze, "doc/Inquery/Query/Chainable.html".freeze, "doc/_index.html".freeze, "doc/class_list.html".freeze, "doc/css/common.css".freeze, "doc/css/full_list.css".freeze, "doc/css/style.css".freeze, "doc/file.README.html".freeze, "doc/file_list.html".freeze, "doc/frames.html".freeze, "doc/index.html".freeze, "doc/js/app.js".freeze, "doc/js/full_list.js".freeze, "doc/js/jquery.js".freeze, "doc/method_list.html".freeze, "doc/top-level-namespace.html".freeze, "inquery.gemspec".freeze, "lib/inquery.rb".freeze, "lib/inquery/exceptions.rb".freeze, "lib/inquery/mixins/raw_sql_utils.rb".freeze, "lib/inquery/mixins/relation_validation.rb".freeze, "lib/inquery/mixins/schema_validation.rb".freeze, "lib/inquery/query.rb".freeze, "lib/inquery/query/chainable.rb".freeze, "test/db/models.rb".freeze, "test/db/schema.rb".freeze, "test/inquery/query/chainable_test.rb".freeze, "test/inquery/query_test.rb".freeze, "test/queries/group/fetch_as_json.rb".freeze, "test/queries/group/fetch_green.rb".freeze, "test/queries/group/fetch_red.rb".freeze, "test/queries/group/filter_with_color.rb".freeze, "test/queries/user/fetch_all.rb".freeze, "test/queries/user/fetch_in_group.rb".freeze, "test/queries/user/fetch_in_group_rel.rb".freeze, "test/test_helper.rb".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "A skeleton that allows extracting queries into atomic, reusable classes.".freeze
  s.test_files = ["test/db/models.rb".freeze, "test/db/schema.rb".freeze, "test/inquery/query/chainable_test.rb".freeze, "test/inquery/query_test.rb".freeze, "test/queries/group/fetch_as_json.rb".freeze, "test/queries/group/fetch_green.rb".freeze, "test/queries/group/fetch_red.rb".freeze, "test/queries/group/filter_with_color.rb".freeze, "test/queries/user/fetch_all.rb".freeze, "test/queries/user/fetch_in_group.rb".freeze, "test/queries/user/fetch_in_group_rel.rb".freeze, "test/test_helper.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<haml>.freeze, [">= 0"])
      s.add_development_dependency(%q<yard>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["= 0.92.0"])
      s.add_development_dependency(%q<redcarpet>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<schemacop>.freeze, ["~> 3.0.8"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<haml>.freeze, [">= 0"])
      s.add_dependency(%q<yard>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, ["= 0.92.0"])
      s.add_dependency(%q<redcarpet>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_dependency(%q<activerecord>.freeze, [">= 0"])
      s.add_dependency(%q<schemacop>.freeze, ["~> 3.0.8"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<haml>.freeze, [">= 0"])
    s.add_dependency(%q<yard>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.92.0"])
    s.add_dependency(%q<redcarpet>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 0"])
    s.add_dependency(%q<schemacop>.freeze, ["~> 3.0.8"])
  end
end