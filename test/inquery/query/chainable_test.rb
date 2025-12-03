require 'test_helper'

require 'queries/user/fetch_in_group_rel'
require 'queries/group/filter_with_color'

module Inquery
  class Query
    class ChainableTest < Minitest::Test
      include TestHelper

      def setup
        self.class.setup_db
        self.class.setup_base_data
      end

      def test_fetch_users_in_group_rels
        result = Queries::User::FetchInGroupRel.run(Group.where('ID IN (1, 2)'))
        assert_equal User.find([1, 2, 3]), result.to_a
      end

      def test_fetch_users_in_group_rels_with_select
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

      def test_filter_with_color
        result = Queries::Group::FilterWithColor.run(Group.where('id > 2'), color: 'green')
        assert_equal Group.find([3]), result.to_a
      end

      def test_call_not_implemented_error
        # Create an anonymous chainable query class that doesn't override call
        query_class = Class.new(Inquery::Query::Chainable) do
          relation class: 'Group'
        end

        # Should raise NotImplementedError when call is not overridden
        assert_raises(NotImplementedError) do
          query_class.run(Group.all)
        end
      end

      def test_chainable_with_default_relation
        query_class = Class.new(Inquery::Query::Chainable) do
          relation class: 'Group'

          def call
            relation.where(color: 'red')
          end
        end

        # Should use default relation when no relation is passed
        result = query_class.run
        assert_equal Group.find([1]), result.to_a
      end

      def test_chainable_with_params_only
        result = Queries::Group::FilterWithColor.run(color: 'red')
        assert_equal Group.find([1]), result.to_a
      end

      def test_chainable_with_empty_relation
        query_class = Class.new(Inquery::Query::Chainable) do
          relation class: 'Group'

          def call
            relation.where(color: 'blue')
          end
        end

        result = query_class.run(Group.where('1=0'))
        assert_empty result.to_a
      end

      def test_chainable_with_different_call_signatures
        query_class = Class.new(Inquery::Query::Chainable) do
          relation class: 'Group'
          schema3 do
            str? :color
          end

          def call
            if osparams.color
              relation.where(color: osparams.color)
            else
              relation
            end
          end
        end

        # Test with relation and params
        result1 = query_class.run(Group.all, color: 'red')
        assert_equal Group.find([1]), result1.to_a

        # Test with params only
        result2 = query_class.run(color: 'green')
        assert_equal Group.find([2, 3]), result2.to_a

        # Test with relation only (should return all)
        result3 = query_class.run(Group.where('id > 1'))
        assert_equal Group.find([2, 3]), result3.to_a
      end

      def test_relation_returns_active_record_relation
        result = Queries::Group::FetchRed.run
        assert_kind_of ActiveRecord::Relation, result
      end
    end
  end
end
