# Change log

## 1.0.11 (2023-08-24)

* Add configuration option `config.default_schema_version` that allows you to
  specify the schema version in effect when using the `schema` DSL method. For
  backwards compatibility, this new setting defaults to `2`.

  Internal reference: `#115859`.

## 1.0.10 (2022-05-19)

* Update gem-internal ruby version and remove `bundler` from gemspec

## 1.0.9 (2021-02-24)

- Update `schemacop` to version `~> 3.0.8`

- Add the following ruby versions to travis testing:
  - `2.5.1`
  - `2.6.2`
  - `2.7.1`
  - `3.0.0`

- Remove ruby `2.3.0` from travis testing

## 1.0.8 (2020-11-24)

- Improve support for schemacop 3.x

## 1.0.7 (2020-11-24)

- Improve support for schemacop 3.x

## 1.0.6 (2020-11-24)

- Improve support for schemacop 3.x

## 1.0.5 (2020-11-24)

- Improve support for schemacop 3.x and document it

## 1.0.4 (2020-11-24)

- Add support for schemacop 3.x (but still using 2.x schema version)

## 1.0.3 (2020-05-12)

- Overwrite parameter hash with the casted version if using 
  casting inside the schemacop `schema` block

## 1.0.2 (2019-10-09)

- Add new mixin `RawSqlUtils`, which provides two methods for
  `Inquery::Query`:

    - `san`: Sanitizes SQL and performs parameter substitution
    - `exec_query`: For directly executing SQL queries

## 1.0.1 (2017-05-17)

- Pin `schemacop` version properly

## 1.0.0 (2017-05-16)

- Initial release
