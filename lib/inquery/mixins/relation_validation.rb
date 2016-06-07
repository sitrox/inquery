module Inquery
  module Mixins
    module RelationValidation
      extend ActiveSupport::Concern

      OPTIONS_SCHEMA = {
        hash: {
          class: { type: String, null: true, required: false },
          fields: { type: :integer, null: true, required: false },
          default_select: { type: :symbol, null: true, required: false },
          default: { type: Proc, null: true, required: false }
        }
      }

      DEFAULT_OPTIONS = {
        # Allows to restrict the class (attribute `klass`) of the relation.
        # Use `nil` to not perform any checks.
        class: nil,

        # Allows to restrict the number of fields / values the relation must
        # select. Use `nil` to not perform any checks.
        fields: nil,

        # If this is set to a symbol, the relation does not have any select
        # fields specified (`select_values` is empty) and `fields` is > 0, it
        # will automatically select the given field. Use `nil` to disable this
        # behavior.
        default_select: :id,

        # This allows to specify a default relation that will be taken if no
        # relation is given. This must be specified as a Proc returning the
        # relation. Set this to `nil` for no default. Validation will fail if no
        # relation is given and no default is set.
        default: nil
      }

      included do
        class_attribute :_relation_options
      end

      module ClassMethods
        # Allows to configure the parameters of the relation this query operates
        # on. See {OPTIONS_SCHEMA} for documentation of the options hash.
        def relation(options = {})
          Schemacop.validate!(OPTIONS_SCHEMA, options)
          self._relation_options = options
        end
      end

      # Validates (and possibly alters) the given relation according to the
      # options specified at class level using the {relation} method.
      def validate_relation!(relation)
        options = DEFAULT_OPTIONS.dup
        options.merge!(self.class._relation_options.dup) if self.class._relation_options

        # ---------------------------------------------------------------
        # Validate presence
        # ---------------------------------------------------------------
        if relation.nil?
          if options[:default]
            relation = options[:default].call
          else
            fail Inquery::Exceptions::InvalidRelation, 'A relation must be given for this query.'
          end
        end

        # ---------------------------------------------------------------
        # Validate class
        # ---------------------------------------------------------------
        expected_class = options[:class].try(:constantize)
        if expected_class && expected_class != relation.klass
          fail Inquery::Exceptions::InvalidRelation, "Unexpected relation class '#{relation.klass}' for this query, expected a '#{expected_class}'."
        end

        # ---------------------------------------------------------------
        # Validate selected fields
        # ---------------------------------------------------------------
        fields_count = relation.select_values.size

        if fields_count == 0 && options[:default_select] && options[:fields] && options[:fields] > 0
          relation = relation.select(options[:default_select])
          fields_count = 1
        end

        if !options[:fields].nil? && fields_count != options[:fields]
          fail Inquery::Exceptions::InvalidRelation, "Expected given relation to select #{options[:fields]} field(s) but got #{fields_count}."
        end

        return relation
      end
    end
  end
end
