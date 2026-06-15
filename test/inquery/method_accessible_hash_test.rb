require 'test_helper'

module Inquery
  class MethodAccessibleHashTest < Minitest::Test
    def test_new
      hash = MethodAccessibleHash.new(name: 'John Smith', age: 70, 'pension' => 300)

      assert_equal 'John Smith', hash.name
      assert_equal 70,           hash.age
      assert_equal 300,          hash.pension
    end

    def test_new_no_arguments
      assert_equal '{}', MethodAccessibleHash.new.to_s
    end

    def test_is_not_a_hash
      # MethodAccessibleHash must NOT subclass Hash, otherwise method access
      # collides with Hash/Enumerable methods (see
      # `test_does_not_collide_with_hash_methods`).
      refute_kind_of ::Hash, MethodAccessibleHash.new
    end

    def test_does_not_collide_with_hash_methods
      # Keys whose names match Hash/Enumerable/Object methods must be returned
      # as values, not invoke the inherited method. Regression test: previously
      # `osparams.group_by` returned an Enumerator instead of the stored value.
      hash = MethodAccessibleHash.new(
        group_by: 'alphabetical',
        count:    5,
        zip:      '8001',
        select:   'everything',
        map:      'world',
        first:    'one',
        merge:    'combine'
      )

      assert_equal 'alphabetical', hash.group_by
      assert_equal 5,              hash.count
      assert_equal '8001',         hash.zip
      assert_equal 'everything',   hash.select
      assert_equal 'world',        hash.map
      assert_equal 'one',          hash.first

      # Bracket access works for the same keys too.
      assert_equal 'alphabetical', hash[:group_by]
      assert_equal '8001',         hash[:zip]
    end

    def test_new_with_nil
      assert_equal '{}', MethodAccessibleHash.new(nil).to_s
    end

    def test_does_not_fake_conversion_methods
      # The object must not pretend to respond to Ruby's implicit type-coercion
      # protocol, otherwise `**hash`, `Hash(obj)` etc. detect the method, call
      # it, receive nil and raise a TypeError. Regression test for splatting.
      hash = MethodAccessibleHash.new(foo: :bar)

      refute_respond_to hash, :to_hash
      refute_respond_to hash, :to_ary
      refute_respond_to hash, :to_str

      assert_raises(NoMethodError) { hash.to_hash }
      assert_equal({ foo: :bar }, { **hash.to_h })
    end

    def test_conversion_method_name_as_key_still_returns_value
      hash = MethodAccessibleHash.new(to_ary: 'value')

      assert_respond_to hash, :to_ary
      assert_equal 'value', hash.to_ary
    end

    def test_to_h
      hash = MethodAccessibleHash.new(foo: :bar)

      assert_instance_of ::Hash, hash.to_h
      assert_equal({ foo: :bar }, hash.to_h)

      # `to_h` returns a copy; mutating it must not affect the original.
      copy = hash.to_h
      copy[:foo] = :changed
      assert_equal :bar, hash.foo
    end

    def test_getter
      hash = MethodAccessibleHash.new(foo: :bar, bar: :baz)
      assert_equal :bar, hash.foo
      assert_equal :baz, hash.bar
    end

    def test_getter_unknown_key_returns_nil
      assert_nil MethodAccessibleHash.new.foo
    end

    def test_setter
      hash = MethodAccessibleHash.new(foo: :bar)
      assert_equal :bar, hash.foo

      hash.foo = :x
      hash.bar = :y

      assert_equal :x, hash.foo
      assert_equal :y, hash.bar
    end

    def test_reference
      hash = MethodAccessibleHash.new
      hash.foo = 42
      assert_equal 42, hash[:foo]
      assert_equal 42, hash.foo

      hash[:bar] = 43
      assert_equal 43, hash[:bar]
      assert_equal 43, hash.bar
    end

    def test_string_keys_are_symbolized
      hash = MethodAccessibleHash.new('foo' => :bar)
      assert_equal :bar, hash.foo
      assert_equal :bar, hash[:foo]
      assert_equal :bar, hash['foo']
    end

    def test_merge
      hash = MethodAccessibleHash.new(foo: :bar).merge(bar: :baz)

      assert_instance_of MethodAccessibleHash, hash
      assert_equal :bar, hash.foo
      assert_equal :baz, hash.bar
      assert_instance_of ::Hash, hash.to_h
    end

    def test_merge_with_string_keys
      hash = MethodAccessibleHash.new(foo: :bar).merge('bar' => :baz)

      assert_equal :bar, hash.foo
      assert_equal :baz, hash.bar
    end

    def test_merge_with_method_accessible_hash
      other = MethodAccessibleHash.new(bar: :baz)
      hash = MethodAccessibleHash.new(foo: :bar).merge(other)

      assert_instance_of MethodAccessibleHash, hash
      assert_equal :bar, hash.foo
      assert_equal :baz, hash.bar
    end

    def test_comparison
      assert_equal MethodAccessibleHash.new(foo: :bar), MethodAccessibleHash.new(foo: :bar)
      refute_equal MethodAccessibleHash.new(foo: :bar, bar: :baz), MethodAccessibleHash.new(foo: :bar)

      # Equal to a plain hash with the same (symbolized) contents.
      assert_equal MethodAccessibleHash.new(foo: :bar), { foo: :bar }
      assert_equal MethodAccessibleHash.new(foo: :bar), { 'foo' => :bar }
      refute_equal MethodAccessibleHash.new(foo: :bar), 'foo'
    end

    def test_respond_to
      assert_respond_to MethodAccessibleHash.new(foo: :bar), :foo
      assert_respond_to MethodAccessibleHash.new, :anything
    end

    def test_frozen
      hash = MethodAccessibleHash.new(name: 'John Smith', age: 70, pension: 300).freeze

      assert_equal 70, hash.age
      assert_equal 300, hash.pension
      assert_equal 'John Smith', hash.name

      assert_raises RuntimeError do
        hash.age = 42
      end

      assert_raises RuntimeError do
        hash.foo = 42
      end

      clone = hash.clone
      assert clone.frozen?
      assert_equal 70, clone.age

      # A frozen clone must be deeply frozen, i.e. its internal data must not
      # be mutable through any path.
      assert clone.instance_variable_get(:@table).frozen?
      assert_raises FrozenError do
        clone.instance_variable_get(:@table)[:age] = 42
      end

      assert_raises RuntimeError do
        clone.age = 42
      end

      assert_raises RuntimeError do
        clone.foo = 42
      end

      duplicate = hash.dup
      refute duplicate.frozen?

      assert_equal 70, duplicate.age
      assert_equal 300, duplicate.pension
      assert_equal 'John Smith', duplicate.name

      # The duplicate is independent and mutable.
      duplicate.age = 42
      assert_equal 42, duplicate.age
      assert_equal 70, hash.age
    end
  end
end
