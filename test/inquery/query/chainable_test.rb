require 'test_helper'

require 'queries/user/fetch_in_group_rel'

module Inquery
  class Query
    class ChainableTest < Minitest::Unit::TestCase
      include TestHelper

      def setup
        self.class.setup_db
        self.class.setup_base_data
      end

      def test_fetch_users_in_group_rels
        result = Queries::User::FetchInGroupRel.run(Group.where('ID IN (1, 2)'))
        assert_equal User.find([1, 2, 3]), result.to_a
      end

      def test_todo_find_a_name
        # Fetch all groups user 1 is in
        group_ids_rel = GroupsUser.where(user_id: 1).select(:group_id)

        # Fetch all users that are in these groups
        result = Queries::User::FetchInGroupRel.run(group_ids_rel)
        assert_equal User.find([1, 2, 3]), result.to_a
      end

      def test_fetch_red_groups
        result = Queries::Group::FetchRed.run
        assert_equal Group.find([1]), result.to_a
      end

      def test_fetch_red_groups_via_scope
        result = Group.red
        assert_equal Group.find([1]), result.to_a
      end

      def test_fetch_green_groups_via_scope
        result = Group.green
        assert_equal Group.find([2, 3]), result.to_a
      end

      def test_fetch_green_groups_via_scope_with_where
        # Where before
        result = Group.where('id > 2').green
        assert_equal Group.find([3]), result.to_a

        # Where after
        result = Group.green.where('id > 2')
        assert_equal Group.find([3]), result.to_a
      end

      def test_fetch_green_groups_with_where
        # With default scope
        result = Queries::Group::FetchGreen.run(Group.where('id > 2'))
        assert_equal Group.find([3]), result.to_a
      end
    end
  end
end
