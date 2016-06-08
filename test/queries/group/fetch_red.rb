module Queries
  module Group
    class FetchRed < Inquery::Query::Chainable
      relation class: 'Group'

      def call
        relation.where(color: 'red')
      end
    end
  end
end
