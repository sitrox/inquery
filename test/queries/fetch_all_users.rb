module Queries
  class FetchAllUsers < Inquery::Query
    def call
      User.all
    end
  end
end
