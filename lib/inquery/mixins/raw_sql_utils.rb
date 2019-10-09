module Inquery
  module Mixins
    module RawSqlUtils
      extend ActiveSupport::Concern

      included do
        # Sanitizes the SQL and substitutes in the supplied variables. Relies on
        # `sanitize_sql_array` from ActiveRecord.
        def san(sql, *variables)
          ActiveRecord::Base.send(:sanitize_sql_array, [sql, *variables])
        end

        # Executes the sql on the connection provided by calling `connection`,
        # which means that the method needs to be defined where this mixin is
        # included. The sql passed in should be sanitized.
        # Returns an instance of `ActiveRecord::Result`.
        def exec_query(sql)
          connection.exec_query(sql, self.class.to_s)
        end
      end
    end
  end
end
