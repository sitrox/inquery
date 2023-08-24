module Inquery
  module Mixins
    module SchemaValidation
      extend ActiveSupport::Concern

      included do
        class_attribute :_schema
        self._schema = nil
      end

      module ClassMethods
        def schema2(*args, &block)
          self._schema = Schemacop::Schema.new(*args, &block)
        end

        def schema3(reference = nil, **options, &block)
          if reference
            self._schema = Schemacop::Schema3.new(:reference, options.merge(path: reference))
          else
            self._schema = Schemacop::Schema3.new(:hash, **options, &block)
          end
        end

        # @see schema2
        def schema(*args, &block)
          case Inquery.default_schema_version
          when 2
            schema2(*args, &block)
          when 3
            schema3(*args, &block)
          else
            fail 'Schemacop schema versions supported are 2 and 3.'
          end
        end
      end
    end
  end
end
