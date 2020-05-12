module Inquery
  class Query
    include Mixins::SchemaValidation
    include Mixins::RawSqlUtils

    attr_reader :params

    # Instantiates the query class using the given arguments
    # and runs `call` and `process` on it.
    def self.run(*args)
      new(*args).run
    end

    # Instantiates the query class using the given arguments
    # and runs `call` on it.
    def self.call(*args)
      new(*args).call
    end

    # Instantiates the query class and validates the given params hash (if there
    # was a validation schema specified).
    def initialize(params = {})
      @params = params

      if _schema
        @params = _schema.validate!(@params)
      end
    end

    # Runs both `call` and `process`.
    def run
      process(call)
    end

    # Override this method to perform the actual query.
    def call
      fail NotImplementedError
    end

    # Override this method to perform an optional result postprocessing.
    def process(results)
      results
    end

    # Returns a copy of the query's params, wrapped in an OpenStruct object for
    # easyer access.
    def osparams
      @osparams ||= OpenStruct.new(params)
    end

    # Provides a connection to the database. May be overridden if a different
    # connection is desired. Defaults to `ActiveRecord::Base.connection`.
    def connection
      ActiveRecord::Base.connection
    end
  end
end
