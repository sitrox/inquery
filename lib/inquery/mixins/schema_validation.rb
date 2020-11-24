module Inquery
  module Mixins
    module SchemaValidation
      extend ActiveSupport::Concern

      included do
        class_attribute :_schema
        self._schema = nil
      end

      module ClassMethods
        def schema(*args, &block)
          if defined?(Schemacop::V2)
            schema = Schemacop::V2::Schema.new(*args, &block)
          else
            schema = Schemacop::Schema.new(*args, &block)
          end

          self._schema = schema
        end
      end
    end
  end
end
