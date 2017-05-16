module Queries
  module User
    class FetchInGroup < Inquery::Query
      schema do
        req :group_id, :integer
      end

      def call
        ::Group.find(osparams.group_id).users
      end
    end
  end
end
