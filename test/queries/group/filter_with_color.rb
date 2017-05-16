module Queries
  module Group
    class FilterWithColor < Inquery::Query::Chainable
      relation class: 'Group'
      schema do
        req :color, :string
      end

      def call
        relation.where(color: osparams.color)
      end
    end
  end
end
