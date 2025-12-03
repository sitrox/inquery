# Migration Guide

This guide helps you migrate from raw ActiveRecord queries to Inquery query classes, and between different versions of Inquery.

## Migrating from Raw ActiveRecord Queries

### Simple Query

**Before (raw ActiveRecord):**
```ruby
# In controller or service
def active_users
  User.where(active: true).order(:name)
end
```

**After (Inquery):**
```ruby
# app/queries/fetch_active_users.rb
class FetchActiveUsers < Inquery::Query
  def call
    User.where(active: true).order(:name)
  end
end

# In controller or service
def active_users
  FetchActiveUsers.run
end
```

**Benefits:**
- Reusable across controllers, services, and background jobs
- Testable in isolation
- Named and documented

### Parameterized Query

**Before (raw ActiveRecord):**
```ruby
def users_by_status(status)
  User.where(status: status).order(:created_at)
end
```

**After (Inquery with schema validation):**
```ruby
class FetchUsersByStatus < Inquery::Query
  schema3 do
    str! :status
  end

  def call
    User.where(status: osparams.status).order(:created_at)
  end
end

# Usage
FetchUsersByStatus.run(status: 'active')
```

**Benefits:**
- Automatic parameter validation
- Type checking
- Clear API documentation through schema

### Complex Query with Post-Processing

**Before:**
```ruby
def user_statistics
  users = User.where(active: true)
  {
    total: users.count,
    premium: users.where(plan: 'premium').count
  }
end
```

**After:**
```ruby
class FetchUserStatistics < Inquery::Query
  def call
    User.where(active: true)
  end

  def process(users)
    {
      total: users.count,
      premium: users.where(plan: 'premium').count
    }
  end
end
```

**Benefits:**
- Separation of query logic and data transformation
- Can call with 'call' to get raw results or 'run' for processed results

### Scope to Chainable Query

**Before:**
```ruby
class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }
  scope :premium, -> { where(plan: 'premium') }
end

# Usage
User.active.premium
```

**After:**
```ruby
class FetchActiveUsers < Inquery::Query::Chainable
  relation class: 'User'

  def call
    relation.where(active: true)
  end
end

class FetchPremiumUsers < Inquery::Query::Chainable
  relation class: 'User'

  def call
    relation.where(plan: 'premium')
  end
end

# Usage as query classes
FetchPremiumUsers.run(FetchActiveUsers.run)

# Or register as scopes
class User < ActiveRecord::Base
  scope :active, FetchActiveUsers
  scope :premium, FetchPremiumUsers
end

User.active.premium
```

**Benefits:**
- Full Ruby classes instead of lambdas
- Can add tests, documentation, and complex logic
- Chainable and composable

## Migrating Between Inquery Versions

### Upcoming Release (1.0.12)

#### OpenStruct Removed

**What changed:**
`OpenStruct` has been replaced with `MethodAccessibleHash` for Ruby 3.5+ compatibility.

**Action required:**
None. The API is identical. Both support dot notation and hash access:

```ruby
osparams.name     # Still works
osparams[:name]   # Still works
```

#### Development Dependencies

**What changed:**
Development dependencies (`minitest`, `rubocop`, `simplecov`, etc.) moved from gemspec to Gemfile.

**Action required:**
None for gem users. For developers:
- Run `bundle install` to install development dependencies
- Dependencies are now managed via Gemfile groups

### Schema Validation: Schemacop v2 vs v3

Inquery supports both Schemacop v2 and v3 schemas. The default is v2 for backward compatibility.

#### Using Schemacop v2 (default)

```ruby
class FetchUsers < Inquery::Query
  schema do
    req :status, :string
    opt :limit, :integer
  end

  def call
    User.where(status: osparams.status)
         .limit(osparams.limit || 10)
  end
end
```

#### Using Schemacop v3 (recommended)

```ruby
class FetchUsers < Inquery::Query
  schema3 do
    str! :status
    int? :limit
  end

  def call
    User.where(status: osparams.status)
         .limit(osparams.limit || 10)
  end
end
```

#### Configuring Default Schema Version

To use Schemacop v3 by default for all queries:

```ruby
# config/initializers/inquery.rb
Inquery.setup do |config|
  config.default_schema_version = 3
end

# Now you can use 'schema' instead of 'schema3'
class FetchUsers < Inquery::Query
  schema do
    str! :status
    int? :limit
  end

  def call
    User.where(status: osparams.status)
  end
end
```

## Best Practices

### Query Organization

Organize queries by domain:

```
app/queries/
├── user/
│   ├── fetch_active.rb
│   ├── fetch_by_email.rb
│   └── search.rb
├── order/
│   ├── fetch_recent.rb
│   └── fetch_by_status.rb
└── base_query.rb
```

### Testing

Test queries in isolation:

```ruby
# test/queries/fetch_active_users_test.rb
class FetchActiveUsersTest < ActiveSupport::TestCase
  test 'returns only active users' do
    active_user = create(:user, active: true)
    inactive_user = create(:user, active: false)

    result = FetchActiveUsers.run

    assert_includes result, active_user
    refute_includes result, inactive_user
  end
end
```

### Naming Conventions

- Use descriptive names: `FetchActiveUsers`, not `Users`
- Prefix with verb: `Fetch`, `Create`, `Update`, `Delete`
- Organize in modules: `User::FetchActive`, `Order::FetchRecent`

### When to Use Query vs. Chainable

**Use `Inquery::Query` when:**
- Query doesn't need to be chained
- Result needs post-processing
- Query uses raw SQL

**Use `Inquery::Query::Chainable` when:**
- Query needs to be chainable
- Using as ActiveRecord scope
- Input and output are both relations
