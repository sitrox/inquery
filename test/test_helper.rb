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

    def setup_base_data
      Group.create!(name: 'Group 1')
      Group.create!(name: 'Group 2')
      Group.create!(name: 'Group 3')

      User.create!(name: 'User 1', groups: Group.find([1, 2]))
      User.create!(name: 'User 2', groups: Group.find([1, 3]))
      User.create!(name: 'User 3', groups: Group.find([2]))
    end
  end
end
