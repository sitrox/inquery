module Inquery
  # A safe alternative for `OpenStruct` in Ruby. It provides convenient method
  # access to a set of key-value pairs, just like `OpenStruct`, but uses
  # `method_missing` instead of defining methods on-the-fly.
  #
  # Unlike a `Hash`, this class deliberately does *not* inherit from `Hash` (or
  # include `Enumerable`). If it did, keys whose names collide with `Hash` /
  # `Enumerable` methods (e.g. `group_by`, `count`, `zip`, `select`, ...) would
  # invoke the inherited method instead of returning the stored value, because
  # `method_missing` is only called for methods that are not already defined.
  #
  # Usage example:
  #
  # ```ruby
  # default_options = { foo: :bar }
  # options = MethodAccessibleHash.new(default_options)
  # options[:color] = :green
  # options.foo   # => :bar
  # options.color # => :green
  # ```
  class MethodAccessibleHash
    # Methods that participate in Ruby's implicit type-coercion protocol. We
    # must neither pretend to respond to these (`respond_to_missing?`) nor
    # fabricate a `nil` value for them (`method_missing`). Otherwise constructs
    # such as `**hash`, `Hash(obj)`, `Array(obj)` or Rails' implicit
    # conversions would detect the method, call it, receive `nil` and raise a
    # `TypeError`. Keys actually present under one of these names are still
    # returned normally.
    CONVERSION_METHODS = %i[to_ary to_a to_hash to_str to_int to_proc].freeze

    # Takes an optional hash as argument and constructs a new
    # MethodAccessibleHash. Keys are symbolized.
    def initialize(hash = {})
      @table = {}
      (hash || {}).each do |key, value|
        @table[key.to_sym] = value
      end
    end

    # Returns the value stored under the given key. Keys are accessed
    # indifferently as the storage is symbolized.
    def [](key)
      @table[key.to_sym]
    end

    # Stores the given value under the given (symbolized) key. Modifying a
    # frozen instance raises a `FrozenError`, because `@table` is frozen
    # alongside the instance (see `freeze` and `initialize_copy`).
    def []=(key, value)
      @table[key.to_sym] = value
    end

    # Returns a (shallow) copy of the underlying data as a plain Hash with
    # symbol keys.
    def to_h
      @table.dup
    end

    # Returns a new MethodAccessibleHash with the given hash merged in.
    def merge(other = {})
      self.class.new(to_h.merge(other.to_h.symbolize_keys))
    end

    # @private
    def ==(other)
      case other
      when MethodAccessibleHash
        to_h == other.to_h
      when ::Hash
        to_h == other.symbolize_keys
      else
        false
      end
    end

    # @private
    def to_s
      @table.to_s
    end
    alias inspect to_s

    # @private
    def freeze
      @table.freeze
      super
    end

    # @private
    def method_missing(method, *args, &_block)
      name = method.to_s
      if name.end_with?('=')
        self[name[0..-2].to_sym] = args.first
      elsif CONVERSION_METHODS.include?(method) && !@table.key?(method)
        super
      else
        @table[method.to_sym]
      end
    end

    # @private
    def respond_to_missing?(method, _include_private = false)
      return false if CONVERSION_METHODS.include?(method) && !@table.key?(method)

      true
    end

    private

    # @private
    def initialize_copy(source)
      super
      # Give the copy its own data so `dup`/`clone` are independent of the
      # source.
      @table = source.to_h
    end

    # @private
    def initialize_clone(source, **kwargs)
      super
      # Unlike `dup`, `clone` preserves the frozen state of the original. The
      # frozen flag is only applied to the clone *after* this hook returns, so
      # we cannot rely on `frozen?` here. Freeze the internal data based on the
      # source (or the explicit `freeze:` keyword on Ruby >= 3.0) instead --
      # otherwise a frozen clone would report `frozen? == true` yet stay
      # mutable through `[]=`.
      freeze = kwargs.fetch(:freeze, nil)
      @table.freeze if freeze || (freeze.nil? && source.frozen?)
    end
  end
end
