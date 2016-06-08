module Queries
  module User
    class FetchAll < Inquery::Query
      def call
        ::User.all
      end
    end
  end
end
