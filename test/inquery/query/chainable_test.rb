require 'test_helper'

require 'queries/fetch_users_in_group_rels'

module Inquery
  class Query
    class ChainableTest < Minitest::Unit::TestCase
      include TestHelper

      def setup
        self.class.setup_db

        Group.create!(name: 'Group 1')
        Group.create!(name: 'Group 2')
        Group.create!(name: 'Group 3')
        User.create!(name: 'User 1', groups: Group.find([1, 2]))
        User.create!(name: 'User 2', groups: Group.find([1, 3]))
        User.create!(name: 'User 3', groups: Group.find([2]))
      end

      def test_fetch_users_in_group_rels
        result = Queries::FetchUsersInGroupRels.run(Group.where('ID IN (1, 2)'))
        assert_equal User.find([1, 2, 3]), result.to_a
      end
    end
  end
end
