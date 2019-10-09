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
      end
    end
  end
end
