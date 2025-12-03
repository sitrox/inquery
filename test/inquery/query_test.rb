require 'test_helper'
require 'queries/user/fetch_all'
require 'queries/user/fetch_in_group'
require 'queries/group/fetch_as_json'

module Inquery
  class QueryTest < Minitest::Test
    include TestHelper

    def setup
      self.class.setup_db
      self.class.setup_base_data
    end

    def test_fetch_all_users
      result = Queries::User::FetchAll.run
      assert_equal User.find([1, 2, 3]), result
    end

    def test_fetch_users_in_group
      result = Queries::User::FetchInGroup.run(group_id: 1)
      assert_equal User.find([1, 2]), result.to_a

      result = Queries::User::FetchInGroup.run(group_id: 2)
      assert_equal User.find([1, 3]), result.to_a

      result = Queries::User::FetchInGroup.run(group_id: 3)
      assert_equal User.find([2]), result.to_a
    end

    def test_fetch_users_in_group_with_invalid_schema
      assert_raises Schemacop::Exceptions::ValidationError do
        Queries::User::FetchInGroup.run
      end
    end

    def test_fetch_groups_as_json
      result = Queries::Group::FetchAsJson.call
      assert_equal Group.all, result
    end

    def test_fetch_groups_as_json_with_process
      result = Queries::Group::FetchAsJson.run
      assert_equal Group.all.to_json, result
    end

    def test_query_with_optional_params
      query_class = Class.new(Inquery::Query) do
        schema3 do
          str! :name
          int? :age
        end

        def call
          User.where(name: osparams.name)
        end
      end

      # With both params
      result = query_class.run(name: 'Alice', age: 30)
      assert_kind_of ActiveRecord::Relation, result

      # With only required param
      result = query_class.run(name: 'Alice')
      assert_kind_of ActiveRecord::Relation, result
    end

    def test_query_without_schema
      query_class = Class.new(Inquery::Query) do
        def call
          User.all
        end
      end

      result = query_class.run
      assert_equal User.all, result
    end

    def test_query_with_empty_result
      query_class = Class.new(Inquery::Query) do
        def call
          User.where('1=0')
        end
      end

      result = query_class.run
      assert_empty result.to_a
    end

    def test_query_returns_nil
      query_class = Class.new(Inquery::Query) do
        def call
          nil
        end
      end

      result = query_class.run
      assert_nil result
    end

    def test_query_with_process_method
      query_class = Class.new(Inquery::Query) do
        def call
          User.all
        end

        def process(results)
          results.count
        end
      end

      result = query_class.run
      assert_equal 3, result
    end

    def test_osparams_returns_method_accessible_hash
      query_class = Class.new(Inquery::Query) do
        schema3 do
          str! :name
        end

        def call
          osparams
        end
      end

      result = query_class.run(name: 'Alice')
      assert_kind_of Inquery::MethodAccessibleHash, result
      assert_equal 'Alice', result.name
      assert_equal 'Alice', result[:name]
    end
  end
end
