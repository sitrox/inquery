module Inquery
  module Exceptions
    class Base < StandardError; end
    class UnknownCallSignature < Base; end
    class InvalidRelation < Base; end
  end
end
