module Inquery
  class Query::Chainable < Query
    include Inquery::Mixins::RelationValidation

    # Allows using this class as an AR scope.
    def self.call(*args)
      return new(*args).call
    end

    def call(*args)
      fail args.inspect
    end

    attr_reader :relation

    def initialize(*args)
      relation, params = parse_init_args(*args)
      @relation = validate_relation!(relation)
      super(params)
    end

    private

    def parse_init_args(*args)
      # new(relation)
      if (args[0].is_a?(ActiveRecord::Relation) || args[0].class < ActiveRecord::Base) && args[1].nil?
        relation = args[0]
        params = {}

      # new(params)
      elsif args[0].is_a?(Hash) && args[1].nil?
        relation = nil
        params = args[0]

      # new(relation, params)
      elsif (args[0].is_a?(ActiveRecord::Relation) || args[0].class < ActiveRecord::Base) && args[1].is_a?(Hash)
        relation = nil
        params = args[1]

      # new()
      elsif args.empty?
        relation = nil
        params = {}

      # Unknown
      else
        fail Inquery::Exceptions::UnknownCallSignature, "Unknown call signature for the query constructor: #{args.collect(&:class)}."
      end

      return relation, params
    end
  end
end
