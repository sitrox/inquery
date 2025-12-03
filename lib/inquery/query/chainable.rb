module Inquery
  # Chainable query class for queries that input and output ActiveRecord relations.
  #
  # Use this class when you want to build queries that can be chained together
  # or used as ActiveRecord scopes. The query receives a relation, transforms
  # it, and returns a new relation.
  #
  # Example:
  #   class FetchActive < Inquery::Query::Chainable
  #     relation class: 'User'
  #
  #     def call
  #       relation.where(active: true)
  #     end
  #   end
  #
  #   User.all.then { |rel| FetchActive.run(rel) }
  #   # Or as a scope:
  #   class User < ActiveRecord::Base
  #     scope :active, FetchActive
  #   end
  class Query::Chainable < Query
    include Inquery::Mixins::RelationValidation

    # Instantiates the query and executes it, allowing use as an AR scope.
    #
    # This enables chainable queries to be used directly as ActiveRecord scopes:
    #   scope :active, FetchActive
    #
    # @param args [Array] Arguments passed to initialize (relation and/or params)
    # @return [ActiveRecord::Relation] The transformed relation
    def self.call(*args)
      return new(*args).call
    end

    # The input ActiveRecord relation that will be transformed by this query.
    #
    # @return [ActiveRecord::Relation]
    attr_reader :relation

    # Initializes a chainable query with a relation and optional parameters.
    #
    # Supports multiple call signatures:
    #   new()                    - Uses default relation from 'relation' DSL
    #   new(relation)            - Uses provided relation
    #   new(params)              - Uses default relation with params
    #   new(relation, params)    - Uses provided relation and params
    #
    # @param args [Array] Variable arguments for relation and/or params
    # @raise [Inquery::Exceptions::UnknownCallSignature] for invalid arguments
    # @raise [Inquery::Exceptions::InvalidRelation] if relation validation fails
    def initialize(*args)
      relation, params = parse_init_args(*args)
      @relation = validate_relation!(relation)
      super(params)
    end

    # Returns the database connection from the relation.
    #
    # This ensures that the query uses the same connection as the input
    # relation, which is important for connection pooling and transactions.
    #
    # @return [ActiveRecord::ConnectionAdapters::AbstractAdapter]
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
