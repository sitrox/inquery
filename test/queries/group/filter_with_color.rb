module Queries
  module Group
    class FilterWithColor < Inquery::Query::Chainable
      relation class: 'Group'
      schema color: :string

      def call
        relation.where(color: osparams.color)
      end
    end
  end
end
