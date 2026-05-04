# Generic tests (dbt-data-privacy)

Package overview: [README](../../README.md).

## k_anonymity

Validates [k-anonymity](https://en.wikipedia.org/wiki/K-anonymity) on a **caller-chosen** set of quasi-identifier columns: every distinct tuple of those columns must appear on **at least `k` rows**. The test uses an **exact** `GROUP BY` / `COUNT(*)` check (see [custom generic tests](https://docs.getdbt.com/best-practices/writing-custom-generic-data-tests?version=1.12)). It does **not** generalize or suppress data for you; it only fails if any equivalence class is too small.

The generic test is implemented for **BigQuery only** (`bigquery__test_k_anonymity`); there is no `default__` fallback for other adapters.

Macros live under [`macros/generic_tests/k_anonymity/`](../../macros/generic_tests/k_anonymity/): [`k_anonymity.sql`](../../macros/generic_tests/k_anonymity/k_anonymity.sql) (test + `bigquery__test_k_anonymity`), [`k_anonymity_validate_arguments.sql`](../../macros/generic_tests/k_anonymity/k_anonymity_validate_arguments.sql), and [`k_anonymity_query_sql_impl.sql`](../../macros/generic_tests/k_anonymity/k_anonymity_query_sql_impl.sql) (`k_anonymity_test_query_sql` and `bigquery__k_anonymity_query_sql_impl`).

**Semantics**

- **Pass:** the compiled query returns zero rows.
- **Fail:** up to `sample_limit` rows are returned. Each row includes the quasi-identifier columns, `group_size`, and `total_violating_groups` (count of violating classes; repeated on each sampled row). Groups are ordered by smallest `group_size` first.
- **NULLs:** standard SQL `GROUP BY` behavior (NULL groups with NULL).

**Arguments**

| Name | Required | Description |
|------|----------|-------------|
| `quasi_identifiers` | yes | Non-empty list of column names on the model (no duplicate names). |
| `k` | yes | Minimum class size; integer ≥ 1 (privacy practice often uses k ≥ 2). |
| `sample_limit` | no | Max rows returned on failure; default `50`. |
| `column_name` | no | Ignored; included so the test can be attached at column or model level. |

**Compiled SQL (tests and debugging)**

`dbt_data_privacy.k_anonymity_test_query_sql(model, quasi_identifiers, k, sample_limit)` returns the same SQL string the generic test executes (after validation). Use it in macro unit tests or to inspect the query; it dispatches to BigQuery-specific SQL only.

**Example (model-level `data_tests`)**

If your project sets `require_generic_test_arguments_property: true`, nest parameters under `arguments`:

When this package is installed as a dependency, qualify the test with the package name (for example `dbt_data_privacy.k_anonymity` in YAML) so dbt resolves `test_k_anonymity` from the package rather than the root project.

```yaml
models:
  - name: my_release_model
    data_tests:
      - dbt_data_privacy.k_anonymity:
          arguments:
            quasi_identifiers: [age_band, gender, postal_sector]
            k: 5
            sample_limit: 20
```

Otherwise you can pass the same parameters at the top level of the test node (see your dbt version and project flags).

## Data Loss Prevention

COMING SOON
