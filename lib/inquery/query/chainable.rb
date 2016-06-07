module Inquery
  class Query::Chainable < Query
    include Inquery::Mixins::RelationValidation

    class_attribute :_default_relation

    attr_reader :relation

    def self.default_relation(default_relation)
      self._default_relation = default_relation
    end

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
        relation = _default_relation.call
        params = args[0]

      # new(relation, params)
      elsif (args[0].is_a?(ActiveRecord::Relation) || args[0].class < ActiveRecord::Base) && args[1].is_a?(Hash)
        relation = args[0]
        params = args[1]

      # new()
      elsif args.empty?
        relation = _default_relation.call
        params = {}

      # Unknown
      else
        fail Inquery::Exceptions::UnknownCallSignature, "Unknown call signature for the query constructor: #{args.collect(&:class)}."
      end

      return relation, params
    end
  end
end
