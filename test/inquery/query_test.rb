require 'test_helper'
require 'queries/fetch_all_users'
require 'queries/fetch_users_in_group'
require 'queries/fetch_groups_as_json'

module Inquery
  class QueryTest < Minitest::Unit::TestCase
    include TestHelper

    def setup
      self.class.setup_db
      self.class.setup_base_data
    end

    def test_fetch_all_users
      result = Queries::FetchAllUsers.run
      assert_equal User.find([1, 2, 3]), result
    end

    def test_fetch_all_users_with_invalid_schema
      assert_raises Schemacop::Exceptions::Validation do
        Queries::FetchAllUsers.run(group_id: 1)
      end
    end

    def test_fetch_users_in_group
      result = Queries::FetchUsersInGroup.run(group_id: 1)
      assert_equal User.find([1, 2]), result.to_a

      result = Queries::FetchUsersInGroup.run(group_id: 2)
      assert_equal User.find([1, 3]), result.to_a

      result = Queries::FetchUsersInGroup.run(group_id: 3)
      assert_equal User.find([2]), result.to_a
    end

    def test_fetch_users_in_group_with_invalid_schema
      assert_raises Schemacop::Exceptions::Validation do
        Queries::FetchUsersInGroup.run
      end
    end

    def test_fetch_groups_as_json
      result = Queries::FetchGroupsAsJson.call
      assert_equal Group.all, result
    end

    def test_fetch_groups_as_json_with_process
      result = Queries::FetchGroupsAsJson.run
      assert_equal Group.all.to_json, result
    end
  end
end
