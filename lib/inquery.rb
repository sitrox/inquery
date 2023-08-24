module Inquery
  mattr_accessor :default_schema_version
  self.default_schema_version = 2

  # Setup method that should be called in a dedicated initializer.
  def self.setup
    yield self
  end
end

require 'uri'
require 'schemacop'

require 'inquery/exceptions'
require 'inquery/mixins/schema_validation'
require 'inquery/mixins/relation_validation'
require 'inquery/mixins/raw_sql_utils'
require 'inquery/query'
require 'inquery/query/chainable'
