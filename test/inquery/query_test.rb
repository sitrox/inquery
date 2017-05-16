require 'test_helper'
require 'queries/user/fetch_all'
require 'queries/user/fetch_in_group'
require 'queries/group/fetch_as_json'

module Inquery
  class QueryTest < Minitest::Unit::TestCase
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
  end
end
