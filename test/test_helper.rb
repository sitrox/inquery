require 'active_record'
require 'minitest/autorun'
require 'inquery'
require 'db/models'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

module TestHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def setup_db
      load File.dirname(__FILE__) + '/db/schema.rb'
    end
  end
end
