module Queries
  module User
    class FetchInGroupRel < Inquery::Query::Chainable
      relation class: 'Group', fields: 1

      def call
        return ::User.where(%(
          id IN (
            SELECT user_id FROM GROUPS_USERS WHERE group_id IN (
              #{relation.to_sql}
            )
          )
        ))
      end
    end
  end
end
