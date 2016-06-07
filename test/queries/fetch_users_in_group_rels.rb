module Queries
  class FetchUsersInGroupRels < Inquery::Query::Chainable
    relation(
      class: 'Group', fields: 1
    )

    def call
      relation = validate_relation(self.relation)

      User.where(%(
        id IN (
          #{relation.to_sql}
        )
      ))
    end
  end
end
