module Queries
  module Group
    class FetchAsJson < Inquery::Query
      def call
        ::Group.all
      end

      def process(result)
        result.to_json
      end
    end
  end
end
