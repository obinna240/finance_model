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

Snowflake schema
- Multi dimension tables 
- Tables feed into multiple dimensions
- Tables are normalized
Star schema