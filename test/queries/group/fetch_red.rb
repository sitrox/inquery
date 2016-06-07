module Queries
  module Group
    class FetchRed < Inquery::Query::Chainable
      relation class: 'Group', default: proc { ::Group.all }

      def call
        relation.where(color: 'red')
      end
    end
  end
end
