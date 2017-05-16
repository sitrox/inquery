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
          schema = Schemacop::Schema.new(*args, &block)

          self._schema = schema
        end
      end
    end
  end
end
