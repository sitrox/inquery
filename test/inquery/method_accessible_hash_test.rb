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

    def test_to_h
      assert MethodAccessibleHash.new.merge(foo: :bar).to_h.instance_of?(::Hash)
    end

    def test_getter
      hash = MethodAccessibleHash.new.merge(foo: :bar, bar: :baz)
      assert_equal :bar, hash.foo
      assert_equal :baz, hash.bar
    end

    def test_setter
      hash = MethodAccessibleHash.new.merge(foo: :bar)
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
    end

    def test_comparison
      assert_equal({ foo: :bar }, MethodAccessibleHash.new(foo: :bar))
      refute_equal({ foo: :bar, bar: :baz }, MethodAccessibleHash.new(foo: :bar))
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
    end
  end
end
