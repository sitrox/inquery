module Inquery
  module Mixins
    module RelationValidation
      extend ActiveSupport::Concern

      if defined?(Schemacop::V3)
        OPTIONS_SCHEMA = Schemacop::Schema3.new(:hash) do
          str? :class
          int? :fields
          sym? :default_select
          rby? :default, [Proc, FalseClass]
        end
      else
        OPTIONS_SCHEMA = Schemacop::Schema.new do
          opt :class, :string
          opt :fields, :integer
          opt :default_select, :symbol
          opt :default, :object, classes: [Proc, FalseClass]
        end
      end

      DEFAULT_OPTIONS = {
        # Allows to restrict the class (attribute `klass`) of the relation. Use
        # `nil` to not perform any checks. The `class` attribute will also be
        # taken to infer a default if no relation is given and you didn't
        # specify any `default`.
        class: nil,

        # This allows to specify a default relation that will be taken if no
        # relation is given. This must be specified as a Proc returning the
        # relation. Set this to `false` for no default. If this is set to `nil`,
        # it will try to infer the default from the option `class` (if given).
        default: nil,

        # Allows to restrict the number of fields / values the relation must
        # select. This is particularly useful if you're using the query as a
        # subquery and need it to return exactly one field. Use `nil` to not
        # perform any checks.
        fields: nil,

        # If this is set to a symbol, the relation does not have any select
        # fields specified (`select_values` is empty) and `fields` is > 0, it
        # will automatically select the given field. Use `nil` to disable this
        # behavior.
        default_select: :id
      }

      included do
        class_attribute :_relation_options
      end

      module ClassMethods
        # Allows to configure the parameters of the relation this query operates
        # on. See {OPTIONS_SCHEMA} for documentation of the options hash.
        def relation(options = {})
          OPTIONS_SCHEMA.validate!(options)
          self._relation_options = options
        end
      end

      # Validates (and possibly alters) the given relation according to the
      # options specified at class level using the `relation` method.
      def validate_relation!(relation)
        options = DEFAULT_OPTIONS.dup
        options.merge!(self.class._relation_options.dup) if self.class._relation_options

        relation_class = options[:class].try(:constantize)

        # ---------------------------------------------------------------
        # Validate presence
        # ---------------------------------------------------------------
        if relation.nil?
          if options[:default]
            relation = options[:default].call
          elsif options[:default].nil? && relation_class
            relation = relation_class.all
          else
            fail Inquery::Exceptions::InvalidRelation, 'A relation must be given for this query.'
          end
        end

        # ---------------------------------------------------------------
        # Validate class
        # ---------------------------------------------------------------
        if relation_class && relation_class != relation.klass
          fail Inquery::Exceptions::InvalidRelation, "Unexpected relation class '#{relation.klass}' for this query, expected a '#{relation_class}'."
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
