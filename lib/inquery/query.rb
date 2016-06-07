module Inquery
  class Query
    include Mixins::SchemaValidation

    attr_reader :params

    def self.run(*args)
      new(*args).run
    end

    def self.call(*args)
      new(*args).call
    end

    def initialize(params = {})
      @params = params
      Schemacop.validate!(self.class._schema, @params)
    end

    def run
      process(call)
    end

    # Override this method to perform an optional result postprocessing.
    def process(results)
      results
    end

    protected

    # Override this method to perform the actual query.
    def call
      fail NotImplementedError
    end

    # Returns a copy of the query's params, wrapped in an OpenStruct object for
    # easyer access.
    def osparams
      @osparams ||= OpenStruct.new(params)
    end
  end
end
