module Inquery
  # A safe alternative for OpenStruct in Ruby. It behaves exactly the same, but
  # does not define methods on-the-fly but uses `method_missing` instead.
  #
  # Usage example:
  #
  # ```ruby
  # default_options = { foo: :bar }
  # options = MethodAccessibleHash.new(default_options)
  # options[:color] = :green
  # options.foo   # => :bar
  # options.color # => green
  # ```
  class MethodAccessibleHash < ::Hash
    # Takes an optional hash as argument and constructs a new
    # MethodAccessibleHash.
    def initialize(hash = {})
      super()

      hash.each do |key, value|
        self[key.to_sym] = value
      end
    end

    # @private
    def merge(**hash)
      super(hash.symbolize_keys)
    end

    # @private
    def method_missing(method, *args, &_block)
      if method.end_with?('=')
        name = method.to_s.gsub(/=$/, '')
        self[name.to_sym] = args.first
      else
        self[method.to_sym]
      end
    end

    # @private
    def respond_to_missing?(_method, _include_private = false)
      true
    end
  end
end
