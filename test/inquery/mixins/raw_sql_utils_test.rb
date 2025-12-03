require 'test_helper'

module Inquery
  module Mixins
    class RawSqlUtilsTest < Minitest::Test
      include TestHelper

      def setup
        self.class.setup_db
        self.class.setup_base_data
      end

      # Test query class
      class TestQuery < Inquery::Query
        def call
          # Intentionally empty
        end
      end

      def test_san_sanitizes_sql_with_variables
        query = TestQuery.new
        result = query.san("SELECT * FROM users WHERE id = ?", 1)

        assert_kind_of String, result
        assert_includes result, "SELECT * FROM users WHERE id = 1"
      end

      def test_san_handles_multiple_variables
        query = TestQuery.new
        result = query.san("SELECT * FROM users WHERE name = ? AND id = ?", 'Alice', 1)

        assert_kind_of String, result
        assert_includes result, "SELECT * FROM users WHERE"
        assert_includes result, "Alice"
        assert_includes result, "1"
      end

      def test_san_handles_special_characters
        query = TestQuery.new
        result = query.san("SELECT * FROM users WHERE name = ?", "O'Brien")

        assert_kind_of String, result
        # ActiveRecord escapes quotes using SQL standard (doubled quotes)
        assert_includes result, "O''Brien"
      end

      def test_exec_query_executes_sql
        query = TestQuery.new
        sql = query.san("SELECT * FROM users WHERE id = ?", 1)
        result = query.exec_query(sql)

        assert_kind_of ActiveRecord::Result, result
        assert_equal 1, result.length
        assert_equal 1, result.first['id']
      end

      def test_exec_query_returns_multiple_rows
        query = TestQuery.new
        sql = "SELECT * FROM users ORDER BY id"
        result = query.exec_query(sql)

        assert_kind_of ActiveRecord::Result, result
        assert_operator result.length, :>, 1
      end
    end
  end
end
