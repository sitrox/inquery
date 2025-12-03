module Inquery
  # Base query class that encapsulates database queries in reusable classes.
  #
  # Subclasses must implement the 'call' method to define the query logic.
  # Optionally, override 'process' to transform the query results.
  #
  # Example:
  #   class FetchActiveUsers < Inquery::Query
  #     def call
  #       User.where(active: true)
  #     end
  #   end
  #
  #   FetchActiveUsers.run # => Returns active users
  class Query
    include Mixins::SchemaValidation
    include Mixins::RawSqlUtils

    attr_reader :params

    # Instantiates the query class with the given params and executes both
    # 'call' and 'process' methods.
    #
    # This is the primary way to execute queries. It runs the query logic
    # defined in 'call' and then passes the results through 'process' for
    # any post-processing.
    #
    # @param args [Hash] Parameters to pass to the query
    # @return [Object] The processed query results
    # @raise [Schemacop::Exceptions::ValidationError] if params don't match schema
    def self.run(*args)
      new(*args).run
    end

    # Instantiates the query class with the given params and executes only
    # the 'call' method, skipping post-processing.
    #
    # @param args [Hash] Parameters to pass to the query
    # @return [Object] The raw query results
    # @raise [Schemacop::Exceptions::ValidationError] if params don't match schema
    def self.call(*args)
      new(*args).call
    end

    # Initializes a new query instance with the given parameters.
    #
    # If a schema is defined using 'schema' or 'schema3', the params will be
    # validated against it before the query is executed.
    #
    # @param params [Hash] Parameters for the query
    # @raise [Schemacop::Exceptions::ValidationError] if params don't match schema
    def initialize(params = {})
      @params = params

      if _schema
        @params = _schema.validate!(@params)
      end
    end

    # Executes the query by calling 'call' and then 'process'.
    #
    # @return [Object] The processed query results
    def run
      process(call)
    end

    # Override this method in subclasses to define the query logic.
    #
    # @return [Object] Query results (typically an ActiveRecord::Relation)
    # @raise [NotImplementedError] if not overridden in subclass
    def call
      fail NotImplementedError
    end

    # Override this method in subclasses to transform the query results.
    #
    # By default, returns the results unchanged. Common uses include
    # converting to JSON, counting records, or extracting specific fields.
    #
    # @param results [Object] The results from the 'call' method
    # @return [Object] The processed results
    def process(results)
      results
    end

    # Returns the query params wrapped in a MethodAccessibleHash for
    # convenient access using dot notation.
    #
    # Example:
    #   schema3 { str! :name }
    #   def call
    #     User.where(name: osparams.name) # Access via dot notation
    #   end
    #
    # @return [MethodAccessibleHash] Params with method access
    def osparams
      @osparams ||= MethodAccessibleHash.new(params)
    end

    # Returns the database connection to use for this query.
    #
    # Override this method if you need to use a different connection than
    # the default ActiveRecord connection.
    #
    # @return [ActiveRecord::ConnectionAdapters::AbstractAdapter]
    def connection
      ActiveRecord::Base.connection
    end
  end
end
