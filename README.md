Install a venv
1. Decide on your python version 3.12
2. run `python3.12 -m venv venv`
3. run `source venv/bin/activate`
4. Install dbt core for BQ or snowflake by doing: `pip install dbt-core dbt-bigquery`
5. run `dbt --version`
6. run `dbt init --skip-profile-setup finance` (This creates our dbt project)

## Where is my profiles.yml
You can run 
`dbt debug --config-dir` to figure out which profiles.yml will be used.
We can also run `dbt run --profiles-dir path-to-directory` to the profiles.yml
directory of our choice.

Or we can export using `export DBT_PROFILES_DIR=path/to_directory`

## To start
We will use oauth to enable dbt access our bq dataset. For this, we will do:
`gcloud auth application-default login` first
and then `dbt debug`.

### Seeds
Run dbt seed - to materialize seed files

### Sources
Sources allow us define schema properties of already imported data into our DWH.
As a result we get additional functionality such as data freshness.
Sources are defined in a `.yml` file nested under a `sources` key.
By default, `schema` will be the same as `name`. Add `schema` only if you
want to use a source name that differs from existing schema.

Now run `dbt compile` to check that the sources are ok.

### Freshness
One benefit of using Source files is being able to make a determination on the freshness of sources.
If our pre-configured sources are stale, freshness enables us determine recency and the need to load.
Source freshness can also be used for trend of data source freshness over time.
Then run `dbt source freshness`
The way this will work is such that dbt will create a query in the query logs of the form:

```commandline
select max(field name) as max_loaded_at, convert_timezone('UTC', convert_timestamp())
as calculated_at from table_name
```
The most recent date returned will be compared against the warn and error fields. If it is older than both fields, either
a warning or an error will be generated.
In ci/cd you can use: `echo $?` to get the response code. Which if it is `0` is a success else `1` is a failure. 


## Snapshots in DBT
SCD or Slowly Changing Dimensions are of 2 different types.
Industry standard is to use type 2 SCDs.
dbt does this by creating a dbt_valid_from and dbt_valid_to date field, and captures changes by setting a start and end date 
for all old records and for dimensional changes it includes a start timestamp as the start and null as the end.
The idea behind this is that users make changes to their data. And so what we want is to be able to capture those changes using snapshots.
Snapshots are managed by yml files.

We can run dbt snapshot frequently using our ci-cd tool, using the timestamp strategy.
We can do this using our orchestration tool e.g Dagster, Airflow.

There are a number of important concepts to review here including:
1. Schema drift - Schema drift detection can be monitored using a Schema registry - which enforces a contract for the data structure, prevening producers from sending data that violates expected schema.
2. Lakehose formats (Delta Lake and Apache Iceberg) - When writing to tables in lAKEHOUSES, A SCHEMA is implicitly enforced and any record that doesn't match the required schema is blocked, quarantined or evolved.

## Testing in DBT
DBT has 2 types of tests:
1. Unit tests
- Singular (SQL tests that users implement)
- Generic (Unique, not_null, accepted_values, relationships)
- Custom Generic tests
- Imported tests from DBT packages
Generic tests are usually easy, because it comes with DBT.
Add a schema.yml file and add our models with the data tests. We do this by declaring the name of the model, and the column and the data test, be it unique, not null etc
2. Data tests
- DBT has 4 built in data tests: unique, not null, relationships and accepted_values
3. Contracts

To run test use `dbt test` and use `dbt test -x` to fail fast.
note that the prove of a tests failure or successes is in running the compiled sql against the db. If it returns a value then the test has failed.
You can also save test failures in the Database/DWH by adding to the dbt project.yml, `data_tests store failures: true`. All failing tests will then be stored in the DWH when db test is run. You can indicate a custom schema where the data tests will be stored. In this example we use `_test_failures`.


Snowflake schema
- Multi dimension tables 
- Tables feed into multiple dimensions
- Tables are normalized
Star schema