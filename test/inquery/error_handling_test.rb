require 'test_helper'

module Inquery
  class ErrorHandlingTest < Minitest::Test
    include TestHelper

    def setup
      self.class.setup_db
      self.class.setup_base_data
    end

    def test_query_without_call_method_raises_not_implemented_error
      query_class = Class.new(Inquery::Query)

      assert_raises(NotImplementedError) do
        query_class.run
      end
    end

    def test_chainable_query_without_call_method_raises_not_implemented_error
      query_class = Class.new(Inquery::Query::Chainable) do
        relation class: 'User'
      end

      assert_raises(NotImplementedError) do
        query_class.run(User.all)
      end
    end

    def test_invalid_relation_class_raises_error
      assert_raises(NameError) do
        Class.new(Inquery::Query::Chainable) do
          relation class: 'NonExistentClass'

          def call
            relation
          end
        end.run
      end
    end

    def test_invalid_relation_type_raises_error
      query_class = Class.new(Inquery::Query::Chainable) do
        relation class: 'User'

        def call
          relation
        end
      end

      assert_raises(Inquery::Exceptions::UnknownCallSignature) do
        query_class.run("not a relation")
      end
    end

    def test_schema_validation_failure_with_missing_required_param
      query_class = Class.new(Inquery::Query) do
        schema3 do
          str! :name
          int! :age
        end

        def call
          User.all
        end
      end

      assert_raises(Schemacop::Exceptions::ValidationError) do
        query_class.run(name: 'Alice')
      end
    end

    def test_schema_validation_failure_with_wrong_type
      query_class = Class.new(Inquery::Query) do
        schema3 do
          int! :age
        end

        def call
          User.all
        end
      end

      assert_raises(Schemacop::Exceptions::ValidationError) do
        query_class.run(age: 'not a number')
      end
    end

    def test_invalid_relation_field_count
      query_class = Class.new(Inquery::Query::Chainable) do
        relation fields: 1

        def call
          relation
        end
      end

      # Passing a relation with more than 1 field should raise an error
      assert_raises(Inquery::Exceptions::InvalidRelation) do
        query_class.run(User.select(:id, :name))
      end
    end

    def test_unknown_call_signature_raises_error
      query_class = Class.new(Inquery::Query::Chainable) do
        def call
          relation
        end
      end

      # Passing invalid arguments should raise UnknownCallSignature
      assert_raises(Inquery::Exceptions::UnknownCallSignature) do
        query_class.new(123, 456, 789)
      end
    end
  end
end
