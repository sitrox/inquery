module Inquery
  class Query::Chainable < Query
    include Inquery::Mixins::RelationValidation

    # Allows using this class as an AR scope.
    def self.call(*args)
      return new(*args).call
    end

    attr_reader :relation

    def initialize(*args)
      relation, params = parse_init_args(*args)
      @relation = validate_relation!(relation)
      super(params)
    end

    # Override the connection method to (re-)use the connection of the relation
    def connection
      @relation.connection
    end

    private

    def parse_init_args(*args)
      first_arg = args[0]
      second_arg = args[1]

      # new() - no arguments
      return [nil, {}] if args.empty?

      # new(relation) or new(params)
      if second_arg.nil?
        if relation_like?(first_arg)
          return [first_arg, {}]
        elsif first_arg.is_a?(Hash)
          return [nil, first_arg]
        end
      end

      # new(relation, params)
      if relation_like?(first_arg) && second_arg.is_a?(Hash)
        return [first_arg, second_arg]
      end

      # Unknown signature
      fail Inquery::Exceptions::UnknownCallSignature,
           "Unknown call signature for the query constructor: #{args.collect(&:class)}."
    end

    def relation_like?(obj)
      obj.is_a?(ActiveRecord::Relation) || (obj.class < ActiveRecord::Base)
    end
  end
end
