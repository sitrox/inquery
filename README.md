[![Unit tests](https://github.com/sitrox/inquery/actions/workflows/ruby.yml/badge.svg)](https://github.com/sitrox/inquery/actions/workflows/ruby.yml)
[![Rubocop check](https://github.com/sitrox/inquery/actions/workflows/rubocop.yml/badge.svg)](https://github.com/sitrox/inquery/actions/workflows/rubocop.yml)
[![Gem Version](https://badge.fury.io/rb/inquery.svg)](https://badge.fury.io/rb/inquery)

# Inquery

A skeleton that allows extracting queries into atomic, reusable classes.

## Installation

To install the **Inquery** gem:

```sh
$ gem install inquery
```

To install it using `bundler` (recommended for any application), add it
to your `Gemfile`:

```ruby
gem 'inquery'
```

## Compatibility

Inquery is tested with the following ruby versions:

* 2.5.1
* 2.6.2
* 2.7.1
* 3.0.1
* 3.2.1

Other ruby versions might work but are not covered by our automated tests.

## Basic usage

```ruby
class FetchUsersWithACar < Inquery::Query
  schema do
    req :color, :symbol
  end

  def call
    User.joins(:cars).where(cars: { color: osparams.color })
  end
end

FetchUsersWithACar.run
# => [<User id: 1 ...]
```

Inquery offers its functionality trough two query base classes: {Inquery::Query}
and {Inquery::Query::Chainable}. See the following sections for detailed
explanations.

## Basic queries

Basic queries inherit from {Inquery::Query}. They receive an optional set of
parameters and commonly return a relation / AR result. An optional `process`
method lets you perform additional result processing steps if needed (i.e.
converting the result to a hash or similar).

For this basic functionality, inherit from {Inquery::Query} and overwrite
the `call` and optionally the `process` method:

```ruby
class FetchRedCarsAsJson < Inquery::Query
  # The `call` method must be overwritten for every query. It is usually called
  # via `run`.
  def call
    Car.where(color: 'red')
  end

  # The `process` method can optionally be overwritten. The base implementation
  # just returns the unprocessed `results` argument.
  def process(results)
    results.to_json
  end
end
```

Queries can be called in various ways:

```ruby
# Instantiates the query class and runs `call` and `process`.
FetchRedCarsAsJson.run(params = {})

# Instantiates the query class and runs `call`. No result processing
# is done.
FetchRedCarsAsJson.call(params = {})

# You can also instantiate the query class manually.
FetchRedCarsAsJson.new(params = {}).run

# Or just run the `call` method without `process`.
FetchRedCarsAsJson.new(params = {}).call
```

Note that it's perfectly fine for some queries to return `nil`, i.e. if they're
writing queries that don't fetch any results.

### Using raw SQL

In some cases it may make sense to push down all computation to the database and
only construct an SQL query for this purpose. To facilitate this,
{Inquery::Query} provides sanitization and query execution methods:

```ruby
# Note: There are better ways of achieving the same result, this is an example
# to demonstrate the methods.
class CheckIfSold < Inquery::Query
  def call
    parts = [
      'SELECT car_id FROM dealership_sales',
      'SELECT car_id FROM dealership_leasings'
    ]

    sql = 'SELECT ? IN (' + parts.join(' UNION ') + ')'

    # The 'san' method takes n+1 arguments: The SQL string and n parameters
    sanitized_sql = san(sql, osparams.car_id)

    # Returns instance of ActiveRecord::Result
    return exec_query(sanitized_sql)
  end

  def process(results)
    results.rows.first.first
  end
end
```

## Chainable queries

Chainable queries are queries that input and output an Active Record relation.
You can access the given relation using the method `relation`:

```ruby
class Queries::User::FetchActive < Inquery::Query::Chainable
  def call
    relation.where(active: 1)
  end
end
```

Input and output relations may or may not be of the same AR class (i.e. you
could pass a relation of `Group`s and receive back a relation of corresponding
`User`s).

### Relation validation

Chainable queries allow you to further specify and validate the relation it
receives. This is done using the static `relation` method:

```ruby
class Queries::User::FetchActive < Inquery::Query::Chainable
  # This will raise an exception when passing a relation which does not
  # correspond to the `User` model.
  relation class: 'User'

  # ....
end
```

The `relation` method accepts the following options:

* `class`

    Allows to restrict the class (attribute `klass`) of the relation.
    Use `nil` to not perform any checks. The `class` attribute will also
    be taken to infer a default if no relation is given and you didn't
    specify any `default`.

* `default`

    This allows to specify a default relation that will be taken if no relation
    is given. This must be specified as a Proc returning the relation. Set this
    to `false` for no default. If this is set to `nil`, it will try to infer the
    default from the option `class` (if given).

* `fields`

    Allows to restrict the number of fields / values the relation must select.
    This is particularly useful if you're using the query as a subquery and need
    it to return exactly one field. Use `nil` to not perform any checks.

* `default_select`

    If this is set to a symbol, the relation does not have any select fields
    specified (`select_values` is empty) and `fields` is > 0, it will
    automatically select the given field. This option defaults to `:id`. Use
    `nil` to disable this behavior.

### Using query classes as regular scopes

Chainable queries can also be used as regular AR model scopes:

```ruby
class User < ActiveRecord::Base
  scope :active, Queries::User::FetchActive
end

class Queries::User::FetchActive < Inquery::Query::Chainable
  # Note that specifying either `class` or `default` is mandatory when using
  # this query class as a scope. The reason for this is that, if the scope is
  # otherwise empty, the class will receive `nil` from AR and therefore has no
  # way of knowing which default class to take.
  relation class: 'User'

  def call
    relation.where(active: 1)
  end
end
```

This approach allows to you use short and descriptive code like `User.active`
but have the possibly complex query code hidden in a separate, reusable class.

Note that when using classes as scopes, the `process` method will be ignored.

### Using the given relation as subquery

In simple cases and all the examples above, we just extend the given relation
and return it again. It is also possible however to just use the given relation
as a subquery and return a completely new relation:


```ruby
class FetchUsersInGroup < Inquery::Query::Chainable
  # Here we do not specify any specific class, as we don't care for it as long
  # as the relation returns exactly one field.
  relation fields: 1

  def call
    return ::User.where(%(
      id IN (
        SELECT user_id FROM GROUPS_USERS WHERE group_id IN (
          #{relation.to_sql}
        )
      )
    ))
  end
end
```

This query could then be called in the following ways:

```ruby
FetchUsersInGroup.run(
  GroupsUser.where(user_id: 1).select(:group_id)
)

# In this example, we're not specifying any select for the relation we pass to
# the query class. This is fine because the query automatically defaults to
# selecting `id` if exactly one field is required (`fields: 1`) and no select is
# specifyed. You can control this further with the option `default_select`.
FetchUsersInGroup.run(Group.where(color: 'red'))
```

## Parameters

Both query classes can be parameterized using a hash called `params`. It is
recommended to specify and validate input parameters in every query. For this
purpose, Inquery provides the `schema` method witch integrates the
[Schemacop](https://github.com/sitrox/schemacop) validation Gem:

```ruby
class SomeQueryClass < Inquery::Query
  schema do
    req :some_param, :integer
    opt :some_other_param, :hash do
      req :some_field, :string
    end
  end

  # ...
end
```

The schema is validated at query class instantiation. An exception will be
raised if the given params do not match the schema specified. See documentation
of the Schemacop Gem for more information on how to specify schemas.

Parameters can be accessed using either `params` or `osparams`. The method
`osparams` automatically wraps `params` in an `OpenStruct` for more convenient
access.

```ruby
class SomeQueryClass < Inquery::Query
  def run
    User.where(
      active: params[:active],
      username: osparams.search
    )
  end
end
```

Inquery supports both schemacop specification versions 2 and 3 using the methods
`schema2` for version 2 and method `schema3` for version 3. You can also use the
method `schema`, which defaults to the schema version configured using
`config.default_schema_version` (see [Configuration](#Configuration)).

## Rails integration

While it is optional, Inquery has been written from the ground up to be
perfectly integrated into any Rails application. It has proven to be a winning
concept to extract all complex queries into separate classes that are
independently executable and testable.

## Configuration

Inquery can be configured globally using an optional initializer:

```ruby
# config/initializers/inquery.rb
Inquery.setup do |config|
  # Specify the default schemacop schema version. Can be one of 2 or 3.
  # config.default_schema_version = 2
end
```

### Directory structure

While not enforced, it is encouraged to use the following structure for storing
your query classes:

* All domain-specific query classes reside in `app/queries`.
* They're in the module `Queries`.
* Queries are further grouped by the model they return (and not the model
  they receive). For instance, a class fetching all active users could be
  located at `Queries::User::FetchActive` and would reside under
  `app/queries/user/fetch_active.rb`.

There are some key benefits to this approach:

* As it should, domain-specific code is located within `app/`.
* As queries are grouped by the model they return and consistently named,
  they're easy to locate and it does not take much thought where to put and
  how to name new query classes.
* As there is a single file per query class, it's a breeze to list all
  queries, i.e. to check their naming for consistency.
* If you're using the same layout for your unit tests, it is absolutely
  clear where to find the corresponding unit tests for each one of your
  query classes.

## Contributors

Thanks to Jeroen Weeink for his insights regarding using query classes as scopes
in his [blog post](http://craftingruby.com/posts/2015/06/29/query-objects-through-scopes.html).

## Copyright

Copyright © 2016 - 2023 Sitrox. See `LICENSE` for further details.
