module Inquery
  module Mixins
    # Provides utilities for working with raw SQL queries in a safe way.
    #
    # This mixin adds two helper methods for executing raw SQL queries:
    # 'san' for sanitizing SQL with parameter substitution, and 'exec_query'
    # for executing sanitized SQL and returning results.
    module RawSqlUtils
      extend ActiveSupport::Concern

      included do
        # Sanitizes SQL and substitutes variables using ActiveRecord's
        # parameterized query mechanism.
        #
        # This method uses ActiveRecord's 'sanitize_sql_array' to safely
        # escape values and prevent SQL injection. Always use this instead of
        # string interpolation when building SQL queries.
        #
        # Example:
        #   sql = san("SELECT * FROM users WHERE age > ? AND city = ?", 18, 'NYC')
        #   # => "SELECT * FROM users WHERE age > 18 AND city = 'NYC'"
        #
        # @param sql [String] SQL query with '?' placeholders
        # @param variables [Array] Values to substitute for placeholders
        # @return [String] Sanitized SQL with values substituted
        def san(sql, *variables)
          ActiveRecord::Base.send(:sanitize_sql_array, [sql, *variables])
        end

        # Executes sanitized SQL and returns the results.
        #
        # The SQL should already be sanitized using the 'san' method or
        # ActiveRecord's query methods. Uses the connection from the 'connection'
        # method, which must be defined in the including class.
        #
        # Example:
        #   sql = san("SELECT COUNT(*) as total FROM users WHERE active = ?", true)
        #   result = exec_query(sql)
        #   result.first['total'] # => 42
        #
        # @param sql [String] Sanitized SQL query to execute
        # @return [ActiveRecord::Result] Query results
        def exec_query(sql)
          connection.exec_query(sql, self.class.to_s)
        end
      end
    end
  end
end
